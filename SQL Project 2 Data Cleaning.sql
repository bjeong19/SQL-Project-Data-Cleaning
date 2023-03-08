--cleaning data in sql queries 


select *
from [sql proj 2].dbo.nash



--Standardize Date Format


select saledate, convert(date,saledate)
from [sql proj 2].dbo.nash


update nash
set saledate = convert(date,saledate)


--Populate Property Address Data


select propertyaddress
from [sql proj 2].dbo.nash
where propertyaddress is null

select *
from [sql proj 2].dbo.nash
order by parcelid

select *
from [sql proj 2].dbo.nash
where propertyaddress is null


select *
from [sql proj 2].dbo.nash a
join [sql proj 2].dbo.nash b
on a.parcelid = b.parcelid
and a.uniqueid <> b.uniqueid


select a.parcelid, a.propertyaddress, b.parcelid, b.propertyaddress, isnull(a.propertyaddress, b.propertyaddress)
from [sql proj 2].dbo.nash a
join [sql proj 2].dbo.nash b
on a.parcelid = b.parcelid
and a.uniqueid <> b.uniqueid
where a.propertyaddress is null

update a
set propertyaddress =  isnull(a.propertyaddress, b.propertyaddress)
from [sql proj 2].dbo.nash a
join [sql proj 2].dbo.nash b
on a.parcelid = b.parcelid
and a.uniqueid <> b.uniqueid



--Breaking Out Address into Individual Columns (Address, City, State)

select propertyaddress
from [sql proj 2].dbo.nash


select 
substring(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as Address,
CHARINDEX(',', propertyaddress)
from [sql proj 2].dbo.nash

select 
substring(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as Address
from [sql proj 2].dbo.nash


select 
substring(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) as Address,
substring(propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress)) as city
from [sql proj 2].dbo.nash



alter table nash
add propertysplitaddress nvarchar(255);
update nash
set propertysplitaddress = substring(propertyaddress, 1, CHARINDEX(',', propertyaddress) -1) 



alter table nash
add propertysplitcity  nvarchar(255);
update nash
set propertysplitcity = substring(propertyaddress, CHARINDEX(',', propertyaddress) +1, len(propertyaddress))



select owneraddress
from [sql proj 2].dbo.nash

select 
parsename(replace(owneraddress, ',', '.'),3),
parsename(replace(owneraddress, ',', '.'),2),
parsename(replace(owneraddress, ',', '.'),1)
from [sql proj 2].dbo.nash

alter table nash
add ownersplitaddress nvarchar(255);
update nash
set ownersplitaddress = parsename(replace(owneraddress, ',', '.'),3)

alter table nash
add ownersplitcity nvarchar(255);
update nash
set ownersplitcity = parsename(replace(owneraddress, ',', '.'),2) 

alter table nash
add ownersplitstate nvarchar(255);
update nash
set ownersplitstate = parsename(replace(owneraddress, ',', '.'),1) 





--Change 1 and 0 to Yes and Noin "Sold as Vacant" field

select distinct(soldasvacant)
from [sql proj 2].dbo.nash



select soldasvacant,
case
when soldasvacant = 1 then 'Yes'
else 'no'
end
from [sql proj 2].dbo.nash

alter column soldasvacant varchar(255);

update nash 
set soldasvacant = 
case
when soldasvacant = 1 then 'Yes'
else 'no'
end 




--Remove Duplicates


with rownumcte as (
select*, 
ROW_NUMBER () over (
partition by parcelid, propertyaddress, saleprice, saledate, legalreference
order by uniqueid 
) as row_num
from [sql proj 2].dbo.nash
)

select*
from rownumcte
where row_num > 1



--Delete Unused Columns

select*
from [sql proj 2].dbo.nash

alter table nash
drop column saledate, owneraddress, taxdistrict, soldasvacantnew, propertyaddress

