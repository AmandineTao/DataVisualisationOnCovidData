
/*
	
	Queries used for Tableau Project
	
	*/
	

	

	

	-- 1. Computing total_cases, total_deaths and deathPercentage
	

	Select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(New_Cases as float))*100 as DeathPercentage
	From PortfolioProject..CovidDeaths$
	--Where location like '%states%'
	where continent is not null 
	--Group By date
	order by 1,2
	

	-- Just a double check based off the data provided
	-- numbers are extremely close so we will keep them - The Second includes "International"  Location
	

	

	--Select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(New_Cases as float))*100 as DeathPercentage
	--From PortfolioProject..CovidDeaths$
	----Where location like '%states%'
	--where location = 'World'
	----Group By date
	--order by 1,2
	

	

	-- 2. TotalDeathCount per Location
	

	-- We take these out as they are not inluded in the above queries and want to stay consistent
	-- European Union is part of Europe
	

	Select location, SUM(cast(new_deaths as float)) as TotalDeathCount
	From PortfolioProject..CovidDeaths$
	--Where location like '%states%'
	Where continent is null 
	and location not in ('World', 'European Union', 'International')
	Group by location
	order by TotalDeathCount desc
	

	

	-- 3. PercentPopulationInfected per location and population
	

	Select Location, Population, MAX(cast(total_cases as float)) as HighestInfectionCount,  Max((cast(total_cases as float)/cast(population as float)))*100 as PercentPopulationInfected
	From PortfolioProject..CovidDeaths$
	--Where location like '%states%'
	Group by Location, Population
	order by PercentPopulationInfected desc
	

	

	-- 4. PercentPopulationInfected per location, population and date
	

	

	Select Location, Population,date, MAX(cast(total_cases as float)) as HighestInfectionCount,  Max((cast(total_cases as float)/cast(population as float)))*100 as PercentPopulationInfected
	From PortfolioProject..CovidDeaths$
	--Where location like '%states%'
	Group by Location, Population, date
	order by PercentPopulationInfected desc
	

	

	

	

	

	

	

	


	-- Further Analysis
	

	

	-- 1. RollingPeopleVaccinated with respect to the date, location, continent and population
	

	Select dea.continent, dea.location, dea.date, dea.population
	, MAX(cast(vac.total_vaccinations as float)) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100
	From PortfolioProject..CovidDeaths$ dea
	Join PortfolioProject..CovidVaccination$ vac
		On dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null 
	group by dea.continent, dea.location, dea.date, dea.population
	order by 1,2,3
	

	

	

	

	-- 2.
	Select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(New_Cases as float))*100 as DeathPercentage
	From PortfolioProject..CovidDeaths$
	--Where location like '%states%'
	where continent is not null 
	--Group By date
	order by 1,2
	

	

	-- Just a double check based off the data provided
	-- numbers are extremely close so we will keep them - The Second includes "International"  Location
	

	

	--Select SUM(cast(new_cases as float)) as total_cases, SUM(cast(new_deaths as float)) as total_deaths, SUM(cast(new_deaths as float))/SUM(cast(New_Cases as float))*100 as DeathPercentage
	--From PortfolioProject..CovidDeaths$
	----Where location like '%states%'
	--where location = 'World'
	----Group By date
	--order by 1,2
	

	

	-- 3.
	

	-- We take these out as they are not inluded in the above queries and want to stay consistent
	-- European Union is part of Europe
	

	Select location, SUM(cast(new_deaths as float)) as TotalDeathCount
	From PortfolioProject..CovidDeaths$
	--Where location like '%states%'
	Where continent is null 
	and location not in ('World', 'European Union', 'International')
	Group by location
	order by TotalDeathCount desc
	

	

	

	-- 4. PercentPopulationInfected with respect to the location and population
	

	Select Location, Population, MAX(cast(total_cases as float)) as HighestInfectionCount,  Max((cast(total_cases as float)/cast(population as float)))*100 as PercentPopulationInfected
	From PortfolioProject..CovidDeaths$
	--Where location like '%states%'
	Group by Location, Population
	order by PercentPopulationInfected desc
	

	

	

	-- 5.
	

	--Select Location, date, total_cases,total_deaths, (cast(total_deaths as float)/cast(total_cases as float))*100 as DeathPercentage
	--From PortfolioProject..CovidDeaths$
	----Where location like '%states%'
	--where continent is not null 
	--order by 1,2
	

	-- took the above query and added population
	Select Location, date, population, total_cases, total_deaths
	From PortfolioProject..CovidDeaths$
	--Where location like '%states%'
	where continent is not null 
	order by 1,2
	

	

	-- 6. Population and vaccinations
	

	

	With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
	as
	(
	Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
	, SUM(CONVERT(float,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
	--, (RollingPeopleVaccinated/population)*100
	From PortfolioProject..CovidDeaths$ dea
	Join PortfolioProject..CovidVaccination$ vac
		On dea.location = vac.location
		and dea.date = vac.date
	where dea.continent is not null 
	--order by 2,3
	)
	Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
	From PopvsVac
	

	

	-- 7. PercentPopulationInfected
	

	Select Location, Population,date, MAX(cast(total_cases as float)) as HighestInfectionCount,  Max((cast(total_cases as float)/cast(population as float)))*100 as PercentPopulationInfected
	From PortfolioProject..CovidDeaths$
	--Where location like '%states%'
	Group by Location, Population, date
	order by PercentPopulationInfected desc
	

	

	

