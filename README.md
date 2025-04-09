# SQL-Data-Mapping & MetaData-Query
SQL Data-Mapping & MetaData-Query is a project showcasing practical solutions to real-world data migration challenges. This repository demonstrates how T-SQL can be used to query metadata, understand the structure of source and legacy systems, and map data accurately across databases.


# Data Mapping & Metadata Querying with T-SQL

## Overview

This project explores one of the most common but often underestimated challenges in data migration: understanding where data sits across systems and how it should be mapped to a new system. As a professional **Data Migration Specialist**, this is a scenario I’ve encountered time and again in real-world projects. 

A major inspiration for this project came from an episode of the **Data Engineering Podcast**, where **Sriram Panyam** described the biggest challenge in data migration as a **data systems issue** rather than simply a data transformation and moving task. That perspective strongly resonated with me.

While there are some tools that have been developed to address data mapping challenges, the solution provided in this project is a T-SQL based approach that can significantly reduce cost by minimizing reliance on external tools.

## Problem Statement

In many of the migrations I have worked on, I mostly encountered inadequate documentation of source or legacy systems.  Often, the biggest blocker to a smooth migration isn’t the transformation logic itself, it's identifying where specific data sits in the legacy system, understanding the cardinality relationships between tables, and determining how this data should be mapped and transformed into the new system.

This project takes a practical approach to solving this problem using **T-SQL to explore and extract metadata** from SQL Server environments.

## Objectives

- Use T-SQL to explore **schema metadata** and answer questions like:
  - Where does a specific field live in the database?
  - What tables reference this column?
  - How can T-SQL be used to map and migrate data from one system's database into another system's database?


## What’s Included

 ### 📂 **Data Files:**
- **[source_data.bak](https://github.com/NayaDamptey/SQL-Data-Mapping-MetaData-Query/blob/main/Data/SourceData.bak)**: Simulated source system data (pre-migration).
- **[target_data.bak](https://github.com/NayaDamptey/SQL-Data-Mapping-MetaData-Query/blob/main/Data/TargetDb.bak)**: Simulated target system data (post-migration, newly mapped).
 ### 📂 **Schema Creation:**
- **[Source_Database.sql](https://github.com/NayaDamptey/SQL-Data-Mapping-MetaData-Query/blob/main/Source%20Database.sql)**: The schema definition for source database.
- **[TargetDB.sql](https://github.com/NayaDamptey/SQL-Data-Mapping-MetaData-Query/blob/main/TargetDB.sql)**: The schema definition for Target database.
- **[Data Mapping](https://github.com/NayaDamptey/SQL-Data-Mapping-MetaData-Query/blob/main/SQL%20Mapping.drawio.png)**: Mapping Diagram

