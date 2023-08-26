Select *
From CovidDeaths$
order by 3,4

Select *
From CovidVaccinations$
order by 3,4

--Select Data that are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths$
order by 1,2


--Total cases vs total Deaths
--Percentage of dying after getting covid in your country
Select location, date, total_cases, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
where location like '%Nepal%'
order by 1,2

--Looking the total cases vs population
--What percentage of people got covid
Select location, date, total_cases, population,(total_cases/Population)*100 as Covidrate
from CovidDeaths$
where location like '%Nepal%'
order by 1,2

--Looking at countries highest infection rate comapre to population
Select location, population,Max(total_cases) as HighestInfection,  Max(total_cases/Population)*100 as Maxpercentofpopulation
from CovidDeaths$
--where location like '%Nepal%'
group by location, population
order by 4

--Looking countries with highest deathrate per population
Select location,population, Max(total_deaths/population)*100 as Deathrate
from PortfolioProject..CovidDeaths$
group by location, population
order by 1,Deathrate desc


--Looking for the countries with highes deathcount per population
Select location, Max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
group by location
order by 2 desc

--Showing the continents with highest DeathCount per population
Select continent, Max(cast(total_deaths as int))as TotalDeathCount
from PortfolioProject..CovidDeaths$
where continent is not null
group by continent
order by 2 desc

--Global Numbers

Select  date,sum( new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage--, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
--where location like '%Nepal%'
where continent is not null
Group by date
order by 1,2

--Total_cases across the world
Select  sum( new_cases) as total_cases, sum(cast(new_deaths as int)) as total_death, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage--, total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths$
--where location like '%Nepal%'
where continent is not null
--Group by date
order by 1,2


--Joing two table by location and dates and looking at total population vs vaccination
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location= vac.location
 and dea.date= vac.date
 where dea.continent is not null
 order  by 2,3,4


 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated 
--(rollingPeopleVaccinated/population)*100
from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location= vac.location
 and dea.date= vac.date
 where dea.continent is not null
 order  by 2,3,4


 --Use CTE
  
  with PopvsVac(continent, location, date, population, new_vaccination, rollingPeoplevaccinated)
as
(
  Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingPeopleVaccinated 
--(rollingPeopleVaccinated/population)*100
from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location= vac.location
 and dea.date= vac.date
 where dea.continent is not null
 --order  by 2,3,4
 )
 select *,(rollingPeopleVaccinated/population)*100
 from PopvsVac

 --Temp Table
 -- Drop the temporary table if it exists


 DROP TABLE if exists #PercentPopulationVaccinated

 Create Table #PercentPopulationVaccinated
 (
 Continent nvarchar(255),
 Location nvarchar(255),
 Date datetime,
 Population numeric,
 New_vaccinations numeric,
 RollingPeopleVaccinated numeric
 )

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(rollingPeopleVaccinated/population)*100
from CovidDeaths$ dea
 join CovidVaccinations$ vac
	on dea.location= vac.location
 and dea.date= vac.date
--where dea.continent is not null
-- order  by 2,3,4

select *, (RollingPeopleVaccinated/population)*100
from #PercentPopulationVaccinated


--Creating our very first view for storing data for later visualization

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
--(rollingPeopleVaccinated/population)*100
from CovidDeaths$ dea
 join CovidVaccinations$ vac
 on dea.location= vac.location
 and dea.date= vac.date
where dea.continent is not null
-- order  by 2,3,4

--Checking view wheather its working or not.(view is created means you need to delete it not like temp for temporary)
  select*
  from PercentPopulationVaccinated
