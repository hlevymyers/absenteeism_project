# Absenteeism_Project
==============================

Flatiron School Final Project
==============================

Goal: The US has a goal of reaching 90% of high school students graduating with a high school diploma within four years. However, in the 2016-17 school year, the rate was 85% which was the highest it has been since the 2010-11 school year. Clearly, there is still room for improvement. 

The goal of this project is to provide a free, publically available app that allows a school administrator the ability to turn a dial or slider and see estimates of behavior changes that research shows improves graduation rates. Although research shows the powerful influence of family and community on educational success, the goal of this project is to only look at factors that a school principal or superintendent could change because they take place within school, such as attendance at school, class subjects, activities, etc. This project used data from the US Department of Education reported graduation rates for the 2016-17 school year and the most recent DoED Office for Civil Rights data set to examine factors that could influence graduation rates. 

Scope: This project will not address all variables that influence graduation rates, only those that have metrics within the OCR data set. It will not address the quality of education in middle or elementary school. It will not address other ways to divide the data beyond large or small graduation classes, such as juvenile justice or alternative schools. It will only look at one school year of data across the entire US. It will not examine data at the state level. The Federal data masks graduation rates at schools with a graduation class less than 200 by reporting rates within a range for privacy reasons. Often states will report individual high school rates for all schools with a different cutoff. This project will not capture individual high school information at the state level. 

Questions:

How to design a model for small schools. Average number, categorical to next level, something else?
How to make sure coefficients are understandable and can translate into a number for an educator?
Which is the best web tool (Rshiny, Flask, Dash, etc.) for this? How to integrate it efficiently?  


Project Organization
------------
The directory structure for this projects is below. Brief descriptions follow the diagram.

```
absenteeism_project
├── LICENSE
│
├── Makefile  : Makefile with commands to perform selected tasks, e.g. `make clean_data`
│
├── README.md : Project README file containing description provided for project.
│
├── .env      : file to hold environment variables (see below for instructions)
│
├── test_environment.py
│
├── data
│   ├── processed : directory to hold interim and final versions of processed data.
│   └── raw : holds original data. This data should be read only.
│
├── models  : holds binary, json (among other formats) of initial, trained models.
│
├── notebooks : holds notebooks for eda, model, and evaluation. Use naming convention yourInitials_projectName_useCase.ipynb
│
├── references : data dictionaries, user notes project, external references.
│
├── reports : interim and final reports, slides for presentations, accompanying visualizations.
│   └── figures
│
├── requirements.txt
│
├── setup.py
│
├── src : local python scripts. Pre-supplied code stubs include clean_data, model and visualize.
    ├── __make_data__.py
    ├── __settings__.py
    ├── clean_data.py
    ├── custom.py
    ├── model.py
    └── visualize.py

```

## Next steps
---------------
### Use with github
As part of the project creation process a local git repository is initialized and committed. If you want to store the repo on github perform the following steps:

1. Create a an empty repository (no License or README) on github with the name absenteeism_project.git.
2. Push the local repo to github. From within the root directory of your local project execute the following:

```
  git remote add origin https://github.com/(Your Github UserName Here)/absenteeism_project.git
  git push -u origin master
```

3. Create a branch with (replace ```branch_name``` with whatever you want to call your branch):
```
  git branch branch_name
```
4. Checkout the branch:
```
  git checkout branch_name
```

If you are working with a group do not share jupyter notebooks. The other members of the group should pull from the master repository, create and checkout their own branch, then create separate notebooks within the notebook directories (e.g., copy and rename the original files). Be sure to follow the naming convention. All subsequent work done on the project should be done in the respective branches.


### Environment Variables
-------------------
The template includes a file ```.env``` which is used to hold values that shouldn't be shared on github, for example an apikey to be used with an online api or other client credentials. The notebooks make these items accessible locally, but will not retain them in the online github repository. You must install ```python-dotenv``` to access this functionality. You can install it stand alone as follows:

```
  pip install -U python-dotenv
```
Or you can install all required packages with the instructions given in the next section.

#### Accessing Environment Variables in Jupyter Notebook
-------------
Notebook access to the constants and variables stored in the ```.env``` file is described here. In a code cell the line (e.g. assume you have a variable named ```APIKEY = 'Your_APIKEY'``` in the  ```.env``` file)
```
  mykey = %env APIKEY`  
```
will place the value ```'Your_APIKEY'``` into ```mykey```

### Installing development requirements
------------
If your current environment does not meet requirements for using this template execute the following:
```
  pip install -r requirements.txt
```
