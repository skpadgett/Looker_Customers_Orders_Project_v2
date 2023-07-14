<h1><span style="color:#2d7eea">README - Your LookML Project</span></h1>

<h2><span style="color:#2d7eea">LookML Overview</span></h2>

LookML is a data modeling language for describing dimensions, fields, aggregates and relationships based on SQL.

LookML is powerful because it:

- **Is all about reusability**: Most data analysis requires the same work to be done over and over again. You extract
raw data, prepare it, deliver an analysis... and then are never able touse any of that work again. This is hugely
inefficient, since the next analysis often involves many of the same steps. With LookML, once you define a
dimension or a measure, you continue to build on it, rather than having to rewrite it again and again.
- **Empowers end users**:  The data model that data analysts and developers create in LookML condenses and
encapsulates the complexity of SQL, it and lets analysts get the knowledge about what their data means out of
their heads so others can use it. This enables non-technical users to do their jobs &mdash; building dashboards,
drilling to row-level detail, and accessing complex metrics &mdash; without having to worry about what’s behind the curtain.
- **Allows for data governance**: By defining business metrics in LookML, you can ensure that Looker is always a
credible single source of truth.

The Looker application uses a model written in LookML to construct SQL queries against a particular database that
business analysts can [Explore](https://docs.looker.com/r/exploring-data) on. For an overview on the basics of LookML, see [What is LookML?](https://docs.looker.com/r/what-is-lookml)

<h2><span style="color:#2d7eea">Learn to Speak Looker</span></h2>
R
A LookML project is a collection of LookML files that describes a set of related [views](https://docs.looker.com/r/terms/view-file), [models](https://docs.looker.com/r/terms/model-file), and [Explores](https://docs.looker.com/r/terms/explore).
- A [view](https://docs.looker.com/r/terms/view-file) (.view files) contains information about how to access or calculate information from each table (or
across multiple joined tables). Here you’ll typically define the view, its dimensions and measures, and its field sets.
- A [model](https://docs.looker.com/r/terms/model-file) (.model file) contains information about which tables to use and how they should be joined together.
Here you’ll typically define the model, its Explores, and its joins.
- An [Explore](https://docs.looker.com/r/terms/explore) is the starting point for business users to query data, and it is the end result of the LookML you are
writing. To see the Explores in this project, select an Explore from the Explore menu.

<h2><span style="color:#2d7eea">Exploring Data</span></h2>

Ad-hoc data discovery is one of Looker’s most powerful and unique features. As you evaluate use cases for your
trial, consider what business areas you would like to explore. Open the Explore menu in the main navigation to see
the Explores you are building.

<h2><span style="color:#2d7eea">The Development Workflow</span></h2>

To support a multi-developer environment, Looker is integrated with Git for version control. Follow [these directions](https://docs.looker.com/r/develop/git-setup)
to set up Git for your project. To edit LookML, expand the Develop drop-down and toggle on [Development Mode](https://docs.looker.com/r/terms/dev-mode). In
Development Mode, changes you make to the LookML model exist only in your account until you commit the
changes and push them to your production model.

<h2><span style="color:#2d7eea">Running validation & tests</span></h2>

Looker can both _validate_ (LookML syntax & inter-dependencies between views) and run _data tests_ directly on the whole project for one specific branch. 

Both these tests are run on the CI before you can merge a PR into the _main_ branch.

They can also be ran manually, either locally (on one's own computer) or in Looker.

<h3>Triggering tests manually</h3>

<h4>Using local dev environement</h4>

First of all, you need to retrieve two environment variables `LOOKERSDK_CLIENT_ID` and `LOOKERSDK_CLIENT_SECRET`. Those should point to your own Looker dev instance and thus being provisionned for your account (ask Data Engineering or any other Looker Admin to get them). 

Then, pretty straightforward process:
```
make init-dev
make validate 
make test
```
Both tests are run on Looker's side, nothing can be tested locally (i.e. all changes have to be committed & pushed to your dev branch).

<h4>Directly in Looker UI</h4>

For a more detailed view of _validation errors_ and _tests failures_, tests can be triggered from Looker UI, on the right branch:
![looker_project_health](https://user-images.githubusercontent.com/6950105/194323692-1dca0a76-37d7-4398-89eb-b22e98924a16.png)

![looker_project_health_details](https://user-images.githubusercontent.com/6950105/194323722-0e58c29b-92b2-4406-aa1e-e81e321d750c.png)


<h2><span style="color:#2d7eea">Additional Resources</span></h2>

To learn more about LookML and how to develop visit:
- [Looker User Guide](https://looker.com/guide)
- [Looker Help Center](https://help.looker.com)
- [Looker University](https://training.looker.com/)
