use CovidAnalysis;

select * from CovidDeaths
where continent is not null
order by 3,4

-- Looking at Total Cases vs Total Deaths
--shows likelihood of dying if you contract covid in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as DeathPercentage
From CovidDeaths
WHERE location like '%Afghanistan%'
order by 1,2;


-- Looking at Total cases vs Population
-- Shows what percentage of population got Covid
select location, date, population, total_cases, (total_cases/population) * 100 as PercentPopulationInfected
From CovidDeaths
order by 1,2

-- Looking at countries with highest infection rate compared to population
select location, population, MAX(total_cases) AS highestInfectionCount, MAX((total_cases/population)) * 100 as PercentPopulationInfected
From CovidDeaths
Group by location, population
order by PercentPopulationInfected desc;

-- Showing the countries with the highest death count per population
select location, MAX(cast(total_deaths as int)) as totalDeathCount
From CovidDeaths
where continent is not null
Group by location
order by 2 desc;

--Showing the continent with the highest death count per population
select continent, MAX(cast(total_deaths as int)) as totalDeathCount
From CovidDeaths
where continent is not null
Group by continent
order by 2 desc;

-- Global numbers
select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases)*100 as
DeathPercentage
from CovidDeaths
where continent is not null
order by 1,2;


-- Looking at total population vs vaccinations
-- USE CTE

WITH popvsvac(continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.location order by dea.location, dea.Date ) as
RollingPeopleVaccinated--, (RollingPeopleVaccinated / population)*100
from covidDeaths dea
Join CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)

SELECT *, (RollingPeopleVaccinated/population)*100
FROM popvsvac

-- Temp table

DROP TABLE IF EXISTS #percentpopulationvaccinated
Create table #percentpopulationvaccinated
(
Continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rollingpeoplevaccinated numeric
)

Insert into #percentpopulationvaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.location order by dea.location, dea.Date ) as
RollingPeopleVaccinated--, (RollingPeopleVaccinated / population)*100
from covidDeaths dea
Join CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select *, (rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated


--creating view to store data for later visualizations

CREATE VIEW percentpopulationvaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as int)) OVER (PARTITION by dea.location order by dea.location, dea.Date ) as
RollingPeopleVaccinated--, (RollingPeopleVaccinated / population)*100
from covidDeaths dea
Join CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3



