SELECT * FROM CovidDeaths
WHERE Continent is not null
ORDER BY 3,4;

--SELECT Data we are going to be using
SELECT Location, Date, total_cases, new_cases, total_deaths, population
FROM CovidDeaths
ORDER BY 1,2;

--Looking at Total Cases vs Total Deaths
SELECT Location, Date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
FROM CovidDeaths
WHERE Location like '%States%'
ORDER BY 1,2;

--Looking at Total Cases vs Population
--shows what percentage of population got covid
SELECT Location, Date, Population, total_cases, (total_cases/Population)*100 as Percentage
FROM CovidDeaths
WHERE Location like '%States%'
ORDER BY 1,2;


--Looking at countries with highest Infection Rate compared to Population
SELECT Location, Population, MAX(total_cases) as HighestInfectionCount, Max((total_cases/Population))*100 as PercentPopulationInfected
FROM CovidDeaths
--WHERE Location like '%States%'
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC;

--Showing countries with highest Death Count per Population
SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
--WHERE Location like '%States%'
GROUP BY Location
ORDER BY TotalDeathCount DESC;


--Let's break things by Continent
SELECT Continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
--WHERE Location like '%States%'
WHERE Continent is not null
GROUP BY Continent
ORDER BY TotalDeathCount DESC;


--SELECT Location, MAX(cast(total_deaths as int)) as TotalDeathCount
--FROM CovidDeaths
--WHERE Location like '%States%'
--WHERE Continent is null
--GROUP BY Location
--ORDER BY TotalDeathCount DESC;


--Showing the Continents with the highest death count per population
SELECT Continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
--WHERE Location like '%States%'
WHERE Continent is not null
GROUP BY Continent
ORDER BY TotalDeathCount DESC;


--Global numbers
SELECT SUM(New_cases) as Total_cases, SUM(cast(new_deaths as int)) as Total_deaths, SUM(cast(New_deaths as int))/SUM(New_cases)*100 as DeathPercentage
FROM CovidDeaths
--WHERE Location like '%States%'
WHERE Continent is not null
--GROUP BY Date
ORDER BY 1,2;

--Looking at total population vs vaccinations
SELECT dea.Continent, dea.Location, dea.Date, dea.Population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition BY dea.Location) as RoolingPeopleVaccinated, --(RollingPeopleVaccinated/Population)*100
FROM CovidDeaths dea JOIN CovidVaccinations vac 
on dea.Location = vac.Location
and dea.Date = vac.Date
WHERE dea.Continent is not null
ORDER BY 2,3


--USE CTE
With PopvsVac (Continent, Location, Date, Population, new_vaccinations, RollingPeopleVaccinated)
as 
(
SELECT dea.Continent, dea.Location, dea.Date, dea.Population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition BY dea.Location) as RoolingPeopleVaccinated --(RollingPeopleVaccinated/Population)*100
FROM CovidDeaths dea JOIN CovidVaccinations vac 
on dea.Location = vac.Location
and dea.Date = vac.Date
WHERE dea.Continent is not null
--ORDER BY 2,3
)
SELECT *, (RollingPeopleVaccinated/Population)*100 
FROM PopvsVac 

--TEMP Table
Drop Table if exists #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric	
)

Insert Into #PercentPopulationVaccinated
SELECT dea.Continent, dea.Location, dea.Date, dea.Population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition BY dea.Location) as RoolingPeopleVaccinated --(RollingPeopleVaccinated/Population)*100
FROM CovidDeaths dea JOIN CovidVaccinations vac 
on dea.Location = vac.Location
and dea.Date = vac.Date
WHERE dea.Continent is not null
--ORDER BY 2,3

SELECT *, (RollingPeopleVaccinated/Population)*100 
FROM #PercentPopulationVaccinated


--Creating view to store data for later visualizations
Create View PercentPopulationVaccinated as 
SELECT dea.Continent, dea.Location, dea.Date, dea.Population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (Partition BY dea.Location) as RoolingPeopleVaccinated --(RollingPeopleVaccinated/Population)*100
FROM CovidDeaths dea JOIN CovidVaccinations vac 
on dea.Location = vac.Location
and dea.Date = vac.Date
WHERE dea.Continent is not null
--ORDER BY 2,3