--Cleaning data for the query
Select *
from NashHousing

--Standarize the date

Select SaleDateConverted, convert(Date,SaleDate)
from NashHousing

Update NashHousing
Set SaleDate= CONVERT(Date,SaleDate)

Alter Table NashHousing
Add SaleDateConverted Date;

Update NashHousing
Set SaleDateConverted = CONVERT(Date, SaleDate)

--Populates Property Address Date

Select PropertyAddress 
from NashHousing
where PropertyAddress is null

Select a.ParcelID, b.ParcelID, a.PropertyAddress,b.PropertyAddress, isnull(a.PropertyAddress, b.PropertyAddress)
from NashHousing a
join NashHousing b
on a.ParcelID = b.ParcelID
And a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

Update a
set PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
from NashHousing a
join NashHousing b
on a.ParcelID = b.ParcelID
And a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null

--Breaking out columns into individuals column By using Substring

Select 
Substring(PropertyAddress, 1,charindex(',', PropertyAddress) -1) as Address,
Substring(PropertyAddress,charindex(',', PropertyAddress) +1, len(PropertyAddress)) As Street
from NashHousing


Alter Table NashHousing
Add PropertySplitAddress Nvarchar(255)

Update NashHousing
Set PropertySplitAddress =Substring(PropertyAddress, 1,charindex(',', PropertyAddress) -1)

Alter Table NashHousing
Add PropertySplitCity Nvarchar(255)

Update NashHousing
Set PropertySplitCity =Substring(PropertyAddress,charindex(',', PropertyAddress) +1, len(PropertyAddress))

Alter Table NashHousing
Drop column PropertySpitAddress 

Select *
fROM NashHousing

-- Breaking Down columns using Parsename
Select OwnerAddress
from NashHousing

Select
Parsename(replace(OwnerAddress, ',', '.'),3 ),
Parsename(replace(OwnerAddress, ',', '.'),2 ),
Parsename(replace(OwnerAddress, ',', '.'),1 )
from NashHousing

Alter Table NashHousing
Add OwnerStreet nvarchar(255)

Update NashHousing
Set OwnerStreet =Parsename(replace(OwnerAddress, ',', '.'),3 )

Alter Table NashHousing
Add OwnerSuburb nvarchar(255)

Update NashHousing
Set OwnerSuburb =Parsename(replace(OwnerAddress, ',', '.'),2)

Alter Table NashHousing
Add OwnerState nvarchar(255)

Update NashHousing
Set OwnerState =Parsename(replace(OwnerAddress, ',', '.'),1)


--Changing all N, Y to Yes and NO

Select Distinct(SoldasVacant), count(SoldasVacant)
from NashHousing
group by SoldAsVacant
order by 2

Select Soldasvacant,
Case when soldasvacant = 'N' Then 'No'
	 when SoldasVacant = 'Y' Then 'Yes'
	 Else SoldasVacant
	 End
from NashHousing

Update NashHousing
Set SoldAsVacant= Case when soldasvacant = 'N' Then 'No'
	 when SoldasVacant = 'Y' Then 'Yes'
	 Else SoldasVacant
	 End

--Removing Duplicates

with RowCTE as(

Select *,
Row_Number() over (
Partition by ParcelID,
						PropertyAddress,
						SalePrice,
						SaleDate,
						LegalReference
						Order By 
						UniqueID)row_num
from NashHousing
)
DELETE 
from RowCTE
where row_num>1
--Order by PropertyAddress

with RowCTE as(

Select *,
Row_Number() over (
Partition by ParcelID,
						PropertyAddress,
						SalePrice,
						SaleDate,
						LegalReference
						Order By 
						UniqueID)row_num
from NashHousing
)
Select
*
from RowCTE
where row_num>1

--Delete Unused Columns


Alter table nashhousing
Drop column Taxdistrict, OwnerAddress
Select *
fROM NashHousing