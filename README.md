# SQL-Data-Migration
SQL Data Migration Portfolio is a project showcasing practical solutions to real-world data migration challenges. This repository demonstrates how T-SQL can be used to query metadata, understand the structure of source and legacy systems, and map data accurately across databases.


# Data Migration Mapping & Metadata Discovery with T-SQL

## Overview

This project explores one of the most common but often underestimated challenges in data migration: understanding where data sits across systems and how it should be mapped to a new environment. As a professional working  as a **Data Migration Specialist** for about two years now, this is a scenario I’ve encountered time and again in real-world projects. 

A major inspiration for this project came from an episode of the **Data Engineering Podcast**, where **Sriram Panyam** described the biggest challenge in data migration as a **data systems issue** rather than simply a data transformation and moving task. That perspective strongly resonated with me.

While there are some modern tools that have been developed to address part of these challenges, the solution provided in this project is a T-SQL based approach can significantly reduce cost by minimizing reliance on external tools.

## Problem Statement

In many of the migrations I have worked on, I mostly encountered inadequate documentation of source or legacy systems.  Often, the biggest blocker to a smooth migration isn’t the transformation logic itself, it's identifying where specific data sits in the legacy system, understanding the cardinality relationships between tables, and determining how this data should be mapped and transformed into the new system.

This project takes a practical approach to solving that problem using **T-SQL to explore and extract metadata** from SQL Server environments.

## Objectives

- Use T-SQL to explore **schema metadata** and answer questions like:
  - Where does a specific field live in the database?
  - What tables reference this column?
  - How can T-SQL be used to map and migrate data from one system database into another system's database?


## What’s Included

📁 sql-data-migration-portfolio/

├── README.md                              # This file
├── data/
│   ├── source_data.bak                    # Simulated source system data (pre-migration data)
│   └── target_data.bak                    # Simulated target system data (post-migration, newly mapped data)
├── sql/
│   ├── 01_create_schema.sql               # Create target schemas
│   ├── 02_load_data.sql                   # Restore data 
│   ├── 03_metadata_discovery.sql          # T-SQL to query system metadata
│   ├── 04_mapping_logic.sql               # Data transformation and mapping logic
└── images/
    └── data_flow_diagram.png              # Diagram of mapping and flow
