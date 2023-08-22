## COVID-19 Data Analysis
This code analyzes COVID-19 data from the CovidDeaths and CovidVaccinations tables in the CovidAnalysis database.

# Queries
The code contains the following queries:

select * from CovidDeaths where continent is not null order by 3,4;
This query selects all rows from the CovidDeaths table where the continent column is not null. This ensures that only countries are included in the analysis. The rows are then ordered by the total_cases and total_deaths columns.
select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage From CovidDeaths WHERE location like '%Afghanistan%' order by 1,2;
This query looks at the total number of cases and deaths in Afghanistan. It also calculates the death percentage, which is the number of deaths divided by the number of cases, multiplied by 100.
select location, date, population, total_cases, (total_cases/population) * 100 as PercentPopulationInfected From CovidDeaths order by 1,2;
This query looks at the total number of cases and population for each country. It then calculates the percentage of the population that has been infected with COVID-19.
select location, population, MAX(total_cases) AS highestInfectionCount, MAX((total_cases/population)) * 100 as PercentPopulationInfected From CovidDeaths Group by location, population order by PercentPopulationInfected desc;
This query identifies the countries with the highest infection rate compared to population. It selects the country, population, highest number of cases, and highest infection rate for each country. The infection rate is calculated by dividing the number of cases by the population, and then multiplying by 100.
select location, MAX(cast(total_deaths as int)) as totalDeathCount From CovidDeaths where continent is not null Group by location order by 2 desc;
This query identifies the countries with the highest death count per population. It selects the country and the total number of deaths per population.
select continent, MAX(cast(total_deaths as int)) as totalDeathCount From CovidDeaths where continent is not null Group by continent order by 2 desc;
This query identifies the continents with the highest death count per population. It selects the continent and the total number of deaths per population.
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage from CovidDeaths where continent is not null order by 1,2;
This query calculates the global number of cases, deaths, and death percentage.
`WITH popvsvac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as ( Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.location order by dea.location, dea.Date ) as RollingPeopleVaccinated--, (RollingPeopleVaccinated / population)*100 from covidDeaths dea Join CovidVaccinations vac ON dea.location = vac.location and dea.date = vac.date where dea.continent is not null --order by 2,3 )
SELECT *, (RollingPeopleVaccinated/population)*100
FROM popvsvac;`

This query uses a CTE (Common Table Expression) to analyze the total population vs vaccinations. The CTE creates a table called popvsvac that contains the continent, location, date, population, new vaccinations, and rolling people vaccinated columns. The final query selects all columns from the CTE and calculates the percentage of the population that has been vaccinated.
`DROP TABLE IF EXISTS #percentpopulationvaccinated Create table #percentpopulationvaccinated ( Continent nvarchar(255), location nvarchar(255), date datetime, population numeric, new_vaccinations numeric, rollingpeoplevaccinated numeric )
