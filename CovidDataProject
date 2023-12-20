-- DEATHS

---- Selecting Data that we ate going to be using

SELECT Location, date, total_cases, new_cases, total_deaths, population 
FROM CovidProject..	CovidDeaths
WHERE continent is not null
ORDER BY 1,2

---- Looking at total cases vs total deaths
---- shows likelihood of dying if you contract covid in your country

SELECT Location, date, total_cases, total_deaths, 
(CONVERT(float, total_deaths) / NULLIF(CONVERT(float, total_cases), 0)) * 100 AS Deathpercentage
FROM CovidProject..	CovidDeaths
WHERE location like '%states%' and continent is not null
ORDER BY 1,2

---- looking at total cases vs population

SELECT Location, date, population, total_cases, 
(CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)) AS PercentPopulationInfected
FROM CovidProject..CovidDeaths
WHERE continent is not null
ORDER BY 1, 2;

---- looking at countries with highest infection rate compared to population

SELECT Location, population, MAX(total_cases) AS highestInfectionCount, 
MAX((CONVERT(float, total_cases) / NULLIF(CONVERT(float, population), 0)))*100 AS PercentPopulationInfected
FROM CovidProject..CovidDeaths
WHERE continent is not null
GROUP BY Location, population
ORDER BY PercentPopulationInfected desc;

----- showing countries with highest death count per population

SELECT Location, MAX(cast(total_deaths as int)) AS TotalDeathsCount
FROM CovidProject..CovidDeaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathsCount desc;

---- CONTINENT

---- showing the continents with the highest death count per population

SELECT location, MAX(cast(total_deaths as int)) AS TotalDeathsCount
FROM CovidProject..CovidDeaths
WHERE continent is null
GROUP BY location
ORDER BY TotalDeathsCount desc;

---- GLOBAL NUMBERS

SELECT SUM(cast (new_cases as int)) as totalCases, SUM(cast(new_deaths as int)) as totalDeaths, 
(CONVERT(float, SUM(cast(new_deaths as int))) / NULLIF(CONVERT(float,  SUM(cast(new_cases as int))), 0)) * 100 AS Deathpercentage
FROM CovidProject..	CovidDeaths
WHERE continent is not null
ORDER BY 1,2;

-- VACCINATIONS

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
FROM CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
	ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null 
ORDER BY 1,2,3;

-- using CTE

with PopvsVac (Continent,Location, Date,Population,New_Vaccinations,RollingPeopleVaccinated)
as
(SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
FROM CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
	ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null)

select *,(cast(RollingPeopleVaccinated as float) / cast (Population as float))*100
from PopvsVac;

-- using temp table

DROP TABLE if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated(
	Continent varchar(255),
	Location varchar(255),
	Date date,
	Population numeric,
	New_vaccinations numeric,
	RollingPeopleVaccinated numeric
);

insert into #PercentPopulationVaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
FROM CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
	ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null;

select *,(cast(RollingPeopleVaccinated as float) / cast (Population as float))*100
from #PercentPopulationVaccinated;

-- creating view to store data for later visualizations

create view PercentPopulationVaccinated as 
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated
FROM CovidProject..CovidDeaths dea
JOIN CovidProject..CovidVaccinations vac
	ON dea.location = vac.location and dea.date = vac.date
WHERE dea.continent is not null;

select * 
from PercentPopulationVaccinated
