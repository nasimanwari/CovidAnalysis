## COVID DATA ANALYSIS
This code analyzes COVID-19 data from the tables CovidDeaths and CovidVaccinations in the CovidAnalysis database.

The code first selects all rows from the CovidDeaths table where the continent column is not null. This ensures that only countries are included in the analysis. The rows are then ordered by the total_cases and total_deaths columns.

The next query looks at the total number of cases and deaths in Afghanistan. It also calculates the death percentage, which is the number of deaths divided by the number of cases, multiplied by 100.

The following query looks at the total number of cases and population for each country. It then calculates the percentage of the population that has been infected with COVID-19.

The next query identifies the countries with the highest infection rate compared to population. It selects the country, population, highest number of cases, and highest infection rate for each country. The infection rate is calculated by dividing the number of cases by the population, and then multiplying by 100.

The next two queries identify the countries and continents with the highest death count per population. They select the country or continent, and the total number of deaths per population.

The next query calculates the global number of cases, deaths, and death percentage.

The final few queries use a CTE (Common Table Expression) and a temp table to analyze the total population vs vaccinations. The CTE creates a table called popvsvac that contains the continent, location, date, population, new vaccinations, and rolling people vaccinated columns. The temp table is used to create a similar table called #percentpopulationvaccinated. The final query creates a view called percentpopulationvaccinated that stores the data from the CTE.

This code can be used to gain insights into the spread of COVID-19 around the world. It can also be used to track vaccination progress and identify countries that may be at risk of high death rates.
