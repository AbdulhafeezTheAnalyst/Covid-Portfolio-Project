select*
from CovidDeaths

select*
from CovidVaccinations

Select continent, location, date, total_cases, total_deaths, population
from CovidDeaths
order by 2,3

create view LikelyhoodOfDying as
select continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where continent is not null
--order by 2,3

create view PercentagePopulationInfected as
select continent, location, date, population, total_cases, (total_cases/population)*100 as PecentagePopulationInfected
from CovidDeaths
where continent is not null
--order by 2,3

create view HighestDeathRatePerCountry as
select location, population, max (cast (total_deaths as int)) as HighestDeathCount, max((total_deaths/population))*100 
as PecentagePopulationDeath
from CovidDeaths
where continent is not null
group by location, population
--order by 2,3

select location, population, max (cast (total_deaths as int)) as HighestDeathCount, max((total_deaths/population))*100 
as PecentagePopulationDeath
from CovidDeaths
where continent is not null
group by location, population
order by  PecentagePopulationDeath desc

create view HighestCasePerPopulation as
select location, population, max (cast (total_cases as int)) as HighestcaseCount, max(total_cases/population)*100 
as PecentagePopulationInfected
from CovidDeaths
where continent is not null
group by location, population
--order by  PecentagePopulationInfected desc

create view HighestDeathCountPerCountry as
select location, max (cast (total_deaths as int)) as HigestDeathsCount
from CovidDeaths
where continent is not null and total_deaths is not null
Group by location
--order by HigestDeathsCount desc

create view HighestDeathCountPerContinent as
select location, max (cast (total_deaths as int)) as TotalDeathCount
from CovidDeaths
where continent is null 
group by location
--order by TotalDeathCount desc

create view GlobalDeathPerCountry as
select date, sum(new_cases) as total_cases, sum(cast (new_deaths as int)) as total_death, sum (cast (new_deaths as int)) /sum (new_cases) *100 
as DeathsPercentage
from CovidDeaths
where continent is not null
group by date
--order by 1,2
  
create view GlobalCasesAndDeath as
select sum(new_cases) as total_cases, sum(cast (new_deaths as int)) as total_death, sum (cast (new_deaths as int)) /sum (new_cases) *100 
as DeathsPercentage
from CovidDeaths
where continent is not null
--group by date
--order by 1,2


select*
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
--order by 3,4

create view NewAndRollingVaccination as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum (cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

with PopulationVaccinated (continent, location, date, population, new_vaccination, RollingPeopleVaccinated)
as 
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum (cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*,(RollingPeopleVaccinated/population)*100
from PopulationVaccinated


drop table if exists PopulationVaccinated
Create table PopulationVaccinated
( continent nvarchar (255),
location nvarchar (255),
date datetime,
population numeric,
new_vaccination numeric,
RollingPeopleVaccinated numeric
)

insert into PopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum (cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

select*,(RollingPeopleVaccinated/population)*100 as PercentageRollingVaccinated
from PopulationVaccinated

create view GlobalPoupulationAndNewVaccination as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum (cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

create view PercentagePopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum (cast (vac.new_vaccinations as int)) over (partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
