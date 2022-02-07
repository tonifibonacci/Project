select *
from PortfolioProject..Covid_Vaccination$
order by 3,4

select *
from PortfolioProject..Deaths$
order by 3,4

-- Select Data to be used

select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..Deaths$
order by 1,2

-- Looking at Total cases vs Total Deaths
-- Shows likelihood of dying if you contract covid over time in Portugal
select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProject..Deaths$
Where Location like 'Portugal'
order by 1,2

-- Looking at Total Cases vs Total Population : shows what percentage of population got covid
select Location, date, total_cases, population, (total_cases/population)*100 as InfectedPopulationPercentage
From PortfolioProject..Deaths$
Where Location like 'Portugal'
order by 1,2

-- What Country has the highest infection rate compared to population
select Location, population, MAX(total_cases) as HihestInfectionCount, MAX((total_cases/population))*100 as InfectedPopulationPercentage
From PortfolioProject..Deaths$
--Where Location like 'Portugal'
Group by location, population
order by InfectedPopulationPercentage desc

-- Showing countries with highest death count 
select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..Deaths$
where continent is not null
Group by location
order by TotalDeathCount desc

-- Highest deaths by continent
select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
From PortfolioProject..Deaths$
where continent is null
Group by location
order by TotalDeathCount desc

--GLOBAL
select date, sum(new_cases) as SumCases, sum(cast(new_deaths as int)) as SumNewDeaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
From PortfolioProject..Deaths$
where continent is not null
Group by date
order by 1,2

-- Total population VS Vaccinations

With PopvsVac (Continent, location, date, population, new_vaccinations, PeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations 
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location order by dea.location, dea.date) as PeopleVaccinated
--, (PeopleVaccinated/population)*100
From PortfolioProject..Deaths$ dea
Join PortfolioProject..Vaccination$ vac
	On dea.location=vac.location
	and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
Select *, (PeopleVaccinated/Population)*100
From PopvsVac



