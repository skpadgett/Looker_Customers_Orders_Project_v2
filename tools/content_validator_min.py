import argparse
import logging
import sys
from pprint import pprint


import looker_sdk
import looker_sdk.error
from looker_sdk.sdk.api40.models import WriteApiSession, WriteGitBranch


LOOKER_MAIN_PROJECT_ID = 'customer_trial'

logger = logging.getLogger()


def main():
    parser = argparse.ArgumentParser(description='GZ Extract wih csv modifications')
    parser.add_argument('branch')
    parser.add_argument('--run-project-validation', dest='run_project_validation', action='store_true')
    parser.add_argument('--run-content-validation', dest='run_content_validation', action='store_true')
    parser.add_argument('--run-lookml-tests', dest='run_lookml_tests', action='store_true')
    args = parser.parse_args()
    logging.basicConfig(level=logging.INFO)

    branch_name = args.branch
    logger.info(f'Running content validation using Looker API on branch: {branch_name}')

    sdk = looker_sdk.init40('looker_config.ini')
    try:
        user_display_name=sdk.me().display_name
        logger.info(f'Logged in using {user_display_name}')
    except looker_sdk.error.SDKError:
        logger.error('Cannot retrieved authenticated user info, check looker credentials setting')

    # switch to dev mode & relevant branch
    sdk.update_session(WriteApiSession(workspace_id="dev"))
    sdk.update_git_branch(LOOKER_MAIN_PROJECT_ID, WriteGitBranch(name=branch_name))

    # fetch latest version of code
    sdk.reset_project_to_remote(LOOKER_MAIN_PROJECT_ID)

    if args.run_lookml_tests:
        if not run_lookml_tests(sdk):
            sys.exit(1)

    if args.run_project_validation:
        if not run_project_validation(sdk):
            sys.exit(1)

    if args.run_content_validation:
        if not run_content_validation(sdk):
            sys.exit(1)


def run_content_validation(sdk):
    # this can be used to validate each panel & dashboards content but this does not validate the LookML only, thus raising a lot of errors even if it does not concern the current dev changes
    validation_res = sdk.content_validation()
    # skiping validation_res for now, can simply iterate over results to see real content errors


def run_project_validation(sdk):
    all_error_count = 0
    project_validation_res = sdk.validate_project(project_id=LOOKER_MAIN_PROJECT_ID)
    for validation_error in project_validation_res.errors:
        pprint(dict(validation_error))
        all_error_count += 1

    logger.info(f'Finished validating project, {len(project_validation_res.errors)} error(s) found.')

    return all_error_count == 0


def run_lookml_tests(sdk):
    all_error_count = 0
    look_ml_tests_res = sdk.run_lookml_test(project_id=LOOKER_MAIN_PROJECT_ID)
    for test_result in look_ml_tests_res:
        if not test_result.success:
            model_name = test_result.model_name
            test_name = test_result.test_name
            error_count = len(test_result.errors)
            all_error_count += error_count
            logger.error(f'Found {error_count} error(s) on {model_name} in test {test_name}')
            for error in test_result.errors:
                pprint(dict(error))

    logger.info(f'Finished running {len(look_ml_tests_res)} tests')

    return all_error_count == 0



if __name__ == '__main__':
    main()
