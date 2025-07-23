# Simonson Lab Database
This application will help users query the data collected from all the studies Simonson Lab has done.

Maintainers: Wanjun Gu (Database), Jane Li (Documentation)

## Install R and RStudio
RStudio will be used to run the web app.
Follow this [link](https://www.dataquest.io/blog/installing-r-on-your-computer/) to install R and Rstudio

## Install the database and the web app
1. Select **<>Code button**, then **Local** tab, then **HTTPS** tab, then **copy the URL** by clicking on the button that look like double pages or by using normal copying. 

![copy url](./README_images/copyURL.png)

2. If you don't have Git Bash, follow this [link](https://www.educative.io/answers/how-to-install-git-bash-in-windows) for installation.
3. **Open Git Bash** and change the working directory to the preferred directory (folder)
    - option one: Go to File Explorer or the Finder and choose the directory (folder) you want to keep this repository in. Right click on the directory and choose to open with Git Bash.
    - option two: open Git Bash and use the command below to get to the right directory, replacing directoryPath with something like C:\Users\userName\Desktop
        ```
        cd directoryPath
        ```
4. **type in the command below with the URL copied** into the place of URL and press enter to create your clone.
    ```
    git clone URL
    ```
    You should see everything from Github in directory you specified. 

## Run the web app
1. Make sure you have R and RStudio installed.
2. Open **install_packages.R** with RStudio. You would only need to do this once. Click the run button on the upper right corner to install the required packages 
    - this script will not reinstall packages that was already installed
3. Open **app.R** and click the run app button on the upper right corner to start the app. You should see the Introduction page when the app starts, like this: 

![screen on start](./README_images/screenOfAppOnStart.png)

You can open it in browser if preferred with the Open in Browser button in the toolbar at the top or by copying the url given on the RStudio console into the browser. Like below

![listening on port](./README_images/listeningPort.png)

4. There are two options. You can **query by subject** or **query by variable**. For both the query by subject and by variable page, it is separated into three blocks: **the query section, the table of all data, and the search result**. Query by variable have one extra function at the very bottom to download the result of the query.

![dashboard section](./README_images/dashboard.png)

The tables can be sorted by on column using the up and down arrow next to the column headers. 

![how to sort a table](./README_images/sortTable.png)

As you can notice, there are another search function in the table of all data and the result table. This search function is **case insensitive** and can match partial words or numbers. This can help you find the required data type/format of the query searches. The query is **case sensitive** and requires the user to input a certain type of data described below. 

- **Query by subject**: search the subject up with their iid to find the studies they have been in and the variables that was taken during the study. The variable is displayed as the variable accession number. The result cannot be downloaded. 
    \* Tip: the initials, first name, last name, or sex can be searched up in the table of all subject to get the iid of the subject. 
- **Query by variable**: the result will return iid of subjects who have the data of the variable searched up and the data itself. The query will follow this syntax: 
    ```
    result_header_name   function   data_type   variable_accession
    ```
- It is required to write if the data type of the variables is **numeric** or **non-numeric**. In this case, all other variables are numeric, except for phv00004 which is sex. If the number is written with letters, it is still numeric. 
- The excepted functions are **average, earliest, and latest**

For example for this query, 

![example query](./README_images/exQuery.png)

- There will be four columns, excluding the iid of the subject, named "sdp", "hct", "sex", and "epas1". 
- For sdp column, it is taking the average of the three variables phv00032, phv00030, and phv00078 of the subjects. For hct column, it is just taking the average of one variable phv00067 of the subjects. For the sex column, it is taking the earliest recorded phv00004 of the subjects. For epas1 column, it is taking the latest recorded phg00014 of the subjects