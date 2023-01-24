SELECT total_deaths_per_million
FROM PortfolioProject01..covid_deaths12


SELECT location,date,total_cases,population,new_cases,total_deaths
FROM PortfolioProject01..covid_deaths12
order by 1,2

-- shows likelihood if you contract covid in your country
SELECT location,date,total_cases,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject01..covid_deaths12
WHERE location like '%sia%'
order by 1,2

--Looking at total cases vs population

	SELECT Location,Population,Max(total_cases) as HighestInfection,Max((total_cases/population))*100 as CasePercentage
	FROM PortfolioProject01..covid_deaths12
	group by Location,Population
	order by CasePercentage desc

-- looking countries with highest death count

SELECT Location,Max(total_deaths) as Highestdeaths
	FROM PortfolioProject01..covid_deaths12
	where continent is not null
	group by Location
	order by Highestdeaths desc
 
 
SELECT continent,Max(total_deaths) as Highestdeaths
	FROM PortfolioProject01..covid_deaths12
	where continent is not null
	group by continent
	order by Highestdeaths desc


SELECT sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, Sum(New_deaths)/Sum(New_cases)*100 as DeathPercentage                                                        
FROM PortfolioProject01..covid_deaths12
--WHERE location like '%sia%' 
where continent is not null
--group by date
order by 1,2


--Looking at Total Population vs Vaccinations


Select dea.continent,dea.location,dea.date,dea.population,dea.new_deaths, vac.new_vaccinations,vac.positive_rate,
SUM(vac.new_vaccinations) OVER(Partition by dea.location order by dea.location,dea.date) as rolling_ppl_vaccinated 
From PortfolioProject01..covid_deaths12 dea
Join PortfolioProject01..covid_vaccinations vac
	on dea.location =vac.location
	and dea.date = vac.date
	Where dea.continent is not null 
	Order by 2,3


--Use Cte(Common Table Expressions)
With PopsVac(Continent,Location,Date,Population,New_Vaccinations,rolling_ppl_vaccinated)
as( 

Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER(Partition by dea.location order by dea.location,dea.date) as rolling_ppl_vaccinated 
From PortfolioProject01..covid_deaths12 dea
Join PortfolioProject01..covid_vaccinations vac
	on dea.location =vac.location
	and dea.date = vac.date
	Where dea.continent is not null 
	--Order by 2,3
	)
	Select*, (rolling_ppl_vaccinated/Population)*100
	From PopsVac
	Where Location = 'Albania'
	


--Temp Table

DROP Table if exists #Percentpplvaccinated
Create Table #Percentpplvaccinated
(
Continent char(255),location char(255),Date datetime,population numeric,new_vaccinations numeric, rolling_ppl_vaccinated numeric
)

Insert into #Percentpplvaccinated

Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER(Partition by dea.location order by dea.location,dea.date) as rolling_ppl_vaccinated 
From PortfolioProject01..covid_deaths12 dea
Join PortfolioProject01..covid_vaccinations vac
	on dea.location =vac.location
	and dea.date = vac.date
	Where dea.continent is not null 
	--Order by 2,3
	
	Select*, (rolling_ppl_vaccinated/Population)*100
	From #Percentpplvaccinated
	WHERE location = 'Albania'
	
--Create View to store data for later visualizations
	
Create View Percentpplvaccinated2 as
Select dea.continent,dea.location,dea.date,dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER(Partition by dea.location order by dea.location,dea.date) as rolling_ppl_vaccinated 
From PortfolioProject01..covid_deaths12 dea
Join PortfolioProject01..covid_vaccinations vac
on dea.location =vac.location
and dea.date = vac.date
Where dea.continent is not null 
--Order by 2,3
	
Create View DeathPercentage69 as
SELECT location,date,total_cases,(total_deaths/total_cases)*100 as DeathPercentage
FROM PortfolioProject01..covid_deaths12
WHERE location like '%sia%'
--order by 1,2

