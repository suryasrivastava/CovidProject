select *
from CovidProject..CovidDeaths
where continent is not null
order by 3,4

select *
from CovidProject..CovidVaccinations
where continent is not null
order by 3,4 

select location,date,total_cases,new_cases,total_deaths,population
from CovidProject..CovidDeaths
where continent is not null
order by location,date

-- looking for Total cases vs Total deaths

select location,cast(date as date) as date,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_percentage
from CovidProject..CovidDeaths
where location= 'india'
order by location,date

-- looking for total cases vs Population 
-- Percentage of population got covid

select location,convert(date,date),population,total_cases,(total_cases/population)*100 as Covid_percentage
from CovidProject..CovidDeaths
where location= 'india'  
order by location,date

-- Countries with highest infection rate compared to population

select location,population,max(total_cases) as highest_infection_count,max((total_cases/population)*100) as Covid_percentage
from CovidProject..CovidDeaths
group by location,population
order by Covid_percentage desc; 

-- Showing countries with highest death count per population

select location,max(cast(total_deaths as int) ) as total_death_count
from CovidProject..CovidDeaths
where continent is not null 
group by location
order by total_death_count desc

--Showing continent with highest death count

select continent,max(cast(total_deaths as int) ) as total_death_count
from CovidProject..CovidDeaths
where continent is not null 
group by continent
order by total_death_count desc

--  Global numbers

select sum(new_cases) as total_cases,sum(cast(new_deaths as int)) as total_deaths,(sum(cast(new_deaths as int)) /sum(new_cases) )* 100 as death_percentage
from covidproject..coviddeaths
where continent is not null
--group by date
order by 1,2


select * 
-from CovidProject..CovidVaccinations

--Looking at total population vs vaccinations

select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
from CovidProject..CovidDeaths dea
join CovidProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
order by 2,3


--Use CTE
with popvsVac (continent,location,date,population,new_vaccinations,rolling_people_vaccinated)
as 
(select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
from CovidProject..CovidDeaths dea
join CovidProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null 
)
select *,(rolling_people_vaccinated/population)*100 as percent_of_vaccinations
from popvsVac


-- Temp Table

drop table if exists percent_population_vacccinations
create table percent_population_vacccinations
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)
insert into percent_population_vacccinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
from CovidProject..CovidDeaths dea
join CovidProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null

select *,(rolling_people_vaccinated/population)*100 as percent_of_vaccinations
from percent_population_vacccinations
 

-- creating a view for visualisation

create  view Total_percent_population_vaccinated as
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as rolling_people_vaccinated
from CovidProject..CovidDeaths dea
join CovidProject..CovidVaccinations vac
on dea.location=vac.location and dea.date=vac.date
where dea.continent is not null



select *
from Total_percent_population_vaccinated


drop view Total_percent_population_vaccinated

