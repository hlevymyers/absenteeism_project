# Absenteeism_Project
==============================

Flatiron School Final Project
==============================

Background: Every American should have a high school graduation diploma. The US wants to have 90% of high school students to achieve that academic goal within four years of high school education. Only 84.6% of high school students earned a diploma during the 2016-17 school year. Not having a high school diploma sets one up for a less successful life, earning less money, having higher medical bills, and spending more time in prison making the net cost to society, a negative $5,400 per high school drop-out. Obviously society and individuals have an incentive to earn a diploma.

As the final project at the Flatiron School Data Science Boot Camp (Washington, DC), I wanted to look at high school graduation rates with the goal of building a tool that shows different actions a school administrator could implement to significantly improve graduation rates. I deliberately choose to only include metrics that a school administrator could change or influence through his or her actions and policies. Factors, such as neighborhood, parental education level, or family income, are known to significantly influence graduation rates, but were not were not included or considered at all. A school principal or superintendent cannot pick up and move the school across town to get a better graduation rate; the principal has the students in the building that are in the building. The goal was to develop a tool to address this reality. 

This github repo includes jupyter notebooks for many steps along the way in developing a tool that could show school administrators steps that could be made that data shows leads to higher graduation rates. A short description of each jupyter notebook:

Absenteeism_load_and_merge_data - Read data from two US Department of Education public data sets and merged them using an inner join into one data set using the NCES School ID as the primary key. The two data sets are:
https://www2.ed.gov/about/offices/list/ocr/docs/crdc-2015-16.html
https://www2.ed.gov/about/inits/ed/edfacts/data-files/acgr-sch-sy2015-16.csv

Building_Features_Notebook - The data disaggregates variables multiple ways, male and female, white, African-American, Hispanic, Asian-American, IEP/504, etc. and covers 34 topical areas including chronic absenteeism of both students and teachers, subjects, curriculum focus, sports participation, harassment and bullying, teacher certification, discipline, budgets, and more. In all situations, the features used the summed the male and female numbers and did not consider disaggregated groups. Even so, there were more than 170 columns of total male, female or other variables. The combined data set was more than 1,800 columns wide and had data on more 21,000 high schools.

Basic data cleaning involved deleting unused columns, totaling male and female number to get a total for the school. Often when schools did not have the data available or immediately available they were given the option of adding a negative number as an indicator to explain the missing data. Those negative numbers were converted to NANs.

Big_and_Small_Schools_EDA - The Department of Education in an effort to protect the privacy of students allows schools to report graduation results in a range for smaller graduation classes. The range is widest for the smallest schools (greater or less than 50% for classes with 6 to 15 students) and narrowest (five percentile points for classes with 61 to 300 students), classes with 301 or more report a single graduation number, not a range. Classes with five or fewer students do not report any number. Because the target variable is the graduation rate, any school that did not report a rate was dropped from the data set.
Because of the graduation range issue, it seemed important to examine if there are significant differences between big and small schools. They seemed similar enough to try and develop a model using just large schools.

Large_School_First_Models - Using only the large schools which have a graduation rate and not a range, prediction modeling was begun. There were about 4,100 schools that fit into this category. There were many missing values which were imputed using the mean. Linear regression was the choosen model to start with and several variations were tried to get better results, including ordinary least squares with statsmodel, Principal Component Analysis (PCA), linear regression with sklearn, linear regression on all variables, linear regression on four key variables, linear regression with multiple lasso penalties, and elastic net. 

RFregressor_Large_Schools - Linear Models using only large schools could not produce a satisfactory model. Random forest as a modeling technique was tried. All the large schools were plotted against graduation rates on the y axis to visualize a pattern. No pattern was detected.

Binning_Models - Began with ten graduation rate bins, 0-9%, 10-19%, 20-29%, ... 90-99%. Did a small amount of exploratory data analysis and tried prediction models using random forest and then tuning it.

Fewer_Bins_Model - In order to use more observations, the decision was to bin all the data, including large schools and bin them in four categories, 90-99%+, 80-89%, 60-79%, and 0-59%. The national graduation rate is 84.6% (school year 2016-17) so the four categories represent above average school graduation rates, average graduation rates, below average and poor performing schools. These bins were unbalanced with 52.57% of schools above average and 9.72% of schools had poor performance. Nonetheless, these bins had very distinct patterns for four variables, chronic absenteeism, sports participation, days missed due to suspensions and the number of non-certified teachers. 

With the four bins, several models were explored, random forests classifier, balanced random forest, random forest with class weights, and grid search. With grid search finding the best parameters took 6.9 hours, and training data could predict graduation rates with 99.9% correctly. With test data, it was 63.8%, indicating the model overfit, making it unsuitable to predict graduation rates with unknown data.

Simple_numbers - Rather than try to predict graduation rates, the decision was made to explore the different levels of graduation and see if there are different patterns in the variables. Through EDA, four variables, chronic absenteeism, sports participation, number of days missed to suspension and number of non-certified teachers were found to have very different patterns for the different graduation rates. The middle 50% of each of the four variables was determined and the decision was to use these four variables as way to provide information for school administrators on how to influence graduation rates.

The Final Product - A Shiny App

High_School_Shiny_App - All the analysis was done in Python, but the Shiny app was built in this jupyter notebook using a R environment. The first draft of the app, generated a table.

Add_numbers_to_csv_for_shiny - Once the decision was made to use a rules based model, a .csv file was put together that only had the necessary information for the shiny app. The final .csv file had 63 columns.

Add_numbers_to_csv_without_missing_values_for_shiny - Once the decision was made to use a rules based model, a .csv file was put together that only had the necessary information for the shiny app. When making the Shiny App it was found that missing values were causing problems. Schools with missing values in the key variables were dropped from the final .csv and app. The total of schools missing enrollment data was one, schools missing data on absenteeism 18, schools missing data on days missed due to suspensions 19, and schools without data on sports participation was 3,461. The final .csv file had 63 columns.

server.R - The server.R builds out the dashboard for each high school and includes the state, district, name, enrollment, graduation, chronic absenteeism, and sports participation rate, number of teachers that are non-certified, and number of days missed to suspensions as reported to the US Department of Education. The dashboard also shows if a school wanted to achieve a higher or better graduation rate what would those rates look like for a school with their enrollment. The gauges show a green improvement range and where the dial where the school is currently. There is also a bubble chart showing each state and how all the schools in the state perform.

ui.R - This ui uses the Shiny Fluid Page for the layout and Google BubbleChart and Gauge for visualizations of each high school.

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
