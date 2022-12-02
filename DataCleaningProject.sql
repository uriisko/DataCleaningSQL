
-- Cleaning Data in SQL Queries

select*
from NashvilleHousing

-- Standartize Date format

Alter table [dbo].[NashvilleHousing]
Alter column saleDate date

--Populate Property Address data

select a.UniqueID, a.ParcelID,a.PropertyAddress, b.UniqueID, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

Update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a join NashvilleHousing b
on a.ParcelID = b.ParcelID
and a.UniqueID <> b.UniqueID
where a.PropertyAddress is null

--Breaking out Address into Individual columns (Address, City, State)

--Property Address:

select SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) as City
from NashvilleHousing

Alter table [dbo].[NashvilleHousing]
ADD PropertysplitAddress varchar(20)

Alter table [dbo].[NashvilleHousing]
Alter column PropertysplitAddress  nvarchar(255)

update NashvilleHousing
set PropertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)
from NashvilleHousing

Alter table [dbo].[NashvilleHousing]
ADD Propertycity varchar(20)

Alter table [dbo].[NashvilleHousing]
Alter column Propertycity nvarchar(255)

update NashvilleHousing
set Propertycity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))
from NashvilleHousing

--Owner Adderss:

select OwnerAddress
from NashvilleHousing

select Parsename(replace(owneraddress, ',','.'),3),
Parsename(replace(owneraddress, ',','.'),2),
Parsename(replace(owneraddress, ',','.'),1)
from NashvilleHousing

Alter table [dbo].[NashvilleHousing]
ADD OwnersplitAddress nvarchar(255)

update NashvilleHousing
set OwnersplitAddress = Parsename(replace(owneraddress, ',','.'),3)
from NashvilleHousing

Alter table [dbo].[NashvilleHousing]
ADD Ownercity nvarchar(255)

update NashvilleHousing
set Ownercity = Parsename(replace(owneraddress, ',','.'),2)
from NashvilleHousing

Alter table [dbo].[NashvilleHousing]
ADD Ownerstate nvarchar(255)

update NashvilleHousing
set Ownerstate = Parsename(replace(owneraddress, ',','.'),1)
from NashvilleHousing

select OwnersplitAddress, Ownercity, Ownerstate
from NashvilleHousing

--Change '0' and '1' to 'Yes' and 'No'

select SoldAsVacant
from NashvilleHousing

select distinct SoldAsVacant, count(soldasvacant)
from NashvilleHousing
group by SoldAsVacant

select SoldAsVacant, case when
SoldAsVacant = 0 then 'No'
else 'Yes' end
from NashvilleHousing

Alter table [dbo].[NashvilleHousing]
Alter column SoldAsVacant varchar(10)

update NashvilleHousing
set SoldAsVacant = case when
SoldAsVacant = 0 then 'No'
else 'Yes' end

--Remove duplicates

with RN_CTE as (
select*, ROW_NUMBER() over (partition by parcelID, PropertyAddress, SaleDate,legalReference order by UniqueID) RN
from NashvilleHousing )

DELETE
from RN_CTE
where RN > 1


-- Delete unused columns

Alter table NashvilleHousing
Drop column propertyAddress, TaxDistrict, OwnerAddress




