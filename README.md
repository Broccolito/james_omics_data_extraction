# James Omics Data Extraction

A comprehensive R-based data extraction and processing pipeline for multi-study omics and phenotypic data from high-altitude population studies. This project extracts and consolidates specific variables across multiple study cohorts (phs00001-phs00012) into standardized, analysis-ready datasets.

## 📊 Project Overview

This repository contains tools for extracting phenotypic and clinical variables from a longitudinal study of high-altitude populations. The data spans multiple collection periods from 2015 to 2022, including physiological measurements, blood biomarkers, pulmonary function tests, and sleep studies conducted at high altitude.

### Study Cohorts

The project processes data from 12 distinct study phases:
- **phs00001**: Trip Aug 2015
- **phs00002**: Trip Dec 2015  
- **phs00003**: Trip Dec 2016
- **phs00004**: Sequenced DNA
- **phs00005**: Trip Dec 2017
- **phs00006**: Trip Mar May 2019
- **phs00007**: Villafuerte in-house
- **phs00008**: Pulmonary Function
- **phs00009**: Sleep Studies
- **phs00010**: Hypoxic Ventilatory Response (HVR)
- **phs00011**: SNP Genotypes 2022
- **phs00012**: EPAS1 Genotype 2021

## 🔧 Features

- **Automated Variable Extraction**: Extracts specific phenotypic variables across multiple study datasets
- **Data Harmonization**: Consolidates measurements from different time points and studies
- **Standardized Output**: Generates consistently formatted CSV files for downstream analysis
- **Flexible Configuration**: Easily modify which variables to extract via the `phv_list.txt` file
- **Quality Control**: Maintains data integrity across multi-study joins

## 📁 Repository Structure

```
james_omics_data_extraction/
├── data/                          # Raw study datasets
│   ├── phs00001.csv              # Individual study files
│   ├── phs00002.csv              # ...
│   ├── ...                       # (phs00001 through phs00012)
│   ├── variables.csv             # Variable metadata and descriptions
│   └── studies.csv               # Study metadata
├── extracted_data/               # Generated output files
│   ├── phv00004_Gender_extracted.csv
│   ├── phv00007_Age_extracted.csv
│   ├── phv00023_Smokes_extracted.csv
│   └── ...                      # Additional extracted variables
├── raw_data/                    # Original source files and processing scripts
├── load_data.R                  # Main extraction script
├── phv_list.txt                 # List of variables to extract
├── .gitignore                   # Git ignore file
└── README.md                    # This documentation
```

## 🚀 Quick Start

### Prerequisites

- R (>= 4.0.0)
- Required R packages:
  ```r
  install.packages(c("dplyr", "data.table"))
  ```

### Usage

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Broccolito/james_omics_data_extraction.git
   cd james_omics_data_extraction
   ```

2. **Configure variables to extract**:
   Edit `phv_list.txt` to specify which variables you want to extract:
   ```
   phv00007  # Age
   phv00004  # Gender
   phv00051  # BMI
   # Add more variables as needed
   ```

3. **Run the extraction**:
   ```r
   source("load_data.R")
   ```

4. **Access extracted data**:
   Processed files will be available in the `extracted_data/` directory with the naming convention:
   ```
   phv{accession}_{variable_name}_extracted.csv
   ```

## 📋 Available Variables

The project currently extracts 21 key variables across multiple domains:

### Demographic & Anthropometric
- **phv00004**: Gender/Sex
- **phv00007**: Age at time of study
- **phv00051**: BMI (Body Mass Index)

### Cardiovascular
- **phv00027**: Heart Rate (HR)
- **phv00028**: Oxygen Saturation (SpO2)
- **phv00032**: Systolic Blood Pressure Average
- **phv00035**: Diastolic Blood Pressure Average

### Metabolic Biomarkers
- **phv00036**: Glucose level
- **phv00037**: Insulin level
- **phv00038**: Cholesterol level
- **phv00039**: HDL concentration
- **phv00040**: LDL concentration
- **phv00041**: Triglycerides level

### Hematological
- **phv00067**: Venous Hematocrit percentage

### Iron Studies
- **phv00042**: Ferritin level
- **phv00043**: Iron level
- **phv00044**: Transferrin level

### Lifestyle
- **phv00023**: Smoking status

### Respiratory Function
- **phv00109**: Hypoxic Ventilatory Response (HVR)
- **phv00110**: Hypercapnic HVR
- **phv00111**: Hypercapnic Ventilatory Response (HCVR)

*For complete variable descriptions, see `data/variables.csv`*

## 📊 Data Output Format

Each extracted variable generates a CSV file with the following structure:

```csv
iid,Variable_phs00001,Variable_phs00002,Variable_phs00003,...
CDP000025,Value1,Value2,Value3,...
CDP000059,Value1,Value2,Value3,...
...
```

Where:
- `iid`: Unique subject identifier
- `Variable_phs0000X`: Variable values from each study phase
- Missing values are represented as empty cells

## 🔍 Data Processing Details

### Extraction Process
1. **Variable Selection**: Reads target variables from `phv_list.txt`
2. **Multi-Study Join**: Performs full outer joins across all study datasets (phs00001-phs00012)
3. **Variable Mapping**: Uses `variables.csv` to map variable accessions to descriptive names
4. **Data Cleaning**: Removes rows with missing subject IDs
5. **Standardized Output**: Saves processed data with consistent naming conventions

### Key Functions
- `extract_data(variable_accession_number)`: Core extraction function that processes a single variable across all studies
- Handles missing data gracefully using full outer joins
- Maintains subject-level linkage across all time points and studies

## 🧬 Research Context

This dataset supports research in:
- **High-altitude physiology**: Understanding adaptation to chronic hypoxia
- **Genetic epidemiology**: Investigating genetic variants associated with altitude adaptation
- **Longitudinal health studies**: Tracking physiological changes over time
- **Chronic Mountain Sickness (CMS)**: Studying maladaptation to high altitude
- **Respiratory function**: Analyzing ventilatory responses and pulmonary function

## 📝 Data Governance

### Privacy & Ethics
- Subject identifiers are de-identified codes (CDP000XXX)
- Identifiable information (names, addresses, phone numbers) are flagged in metadata
- Data usage should comply with relevant IRB/ethics approvals

### Quality Assurance
- Variable definitions are standardized across studies
- Missing data patterns preserved for analytical transparency
- Temporal relationships maintained through study phase indicators

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-variable`)
3. Add your variable to `phv_list.txt`
4. Test the extraction process
5. Commit your changes (`git commit -am 'Add new variable extraction'`)
6. Push to the branch (`git push origin feature/new-variable`)
7. Create a Pull Request

## 📚 Citation

If you use this dataset or code in your research, please cite:

```
[Citation information to be added based on associated publications]
```

## 📞 Support

For questions about:
- **Data extraction**: Create an issue in this repository
- **Variable definitions**: Refer to `data/variables.csv` or contact the data stewards
- **Research collaboration**: Contact the principal investigators

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Last Updated**: July 2025  
**Maintainer**: [Maintainer information]  
**Version**: 1.0.0
