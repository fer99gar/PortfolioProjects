

--Standarize Date Format

Select saledate, CONVERT(date, saledate)
from dbo.NashvilleHousing

Update dbo.NashvilleHousing
set SaleDate = CONVERT(date, SaleDate)


update dbo.NashvilleHousing
set SaleDate = CONVERT(date, saleDate)


--------------------------------------------------------------------------
--Populate Property Address date

Select *
from dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


SELECT  
    a.ParcelID,
    a.PropertyAddress,
    b.ParcelID,
    b.PropertyAddress,
    ISNULL(a.PropertyAddress, b.PropertyAddress) AS FilledAddress
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
    ON a.ParcelID = b.ParcelID
   AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;



Update a
set PropertyAddress= ISNULL(a.PropertyAddress, b.PropertyAddress)
FROM dbo.NashvilleHousing a
JOIN dbo.NashvilleHousing b
    ON a.ParcelID = b.ParcelID
   AND a.UniqueID <> b.UniqueID
   WHERE a.PropertyAddress IS NULL;


   ------------------------------------------------------------------

  --Breaking out Address into Individual Columns(Address, City, State)

Select PropertyAddress
from dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select
SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) as address,
SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress) +1, len(propertyAddress) ) as address
from dbo.NashvilleHousing



Alter Table dbo.NashvilleHousing
add PropertySplitAddress nvarchar(255)

update dbo.NashvilleHousing
set PropertySplitAddress = SUBSTRING(propertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)

Alter Table dbo.NashvilleHousing
add PropertySplitCity nvarchar(255)

update dbo.NashvilleHousing
set PropertySplitCity = SUBSTRING(propertyAddress, CHARINDEX(',', PropertyAddress) +1, len(propertyAddress) )

select*
from PortfolioProject..NashvilleHousing




select OwnerAddress
from PortfolioProject..NashvilleHousing

Select
PARSENAME(replace (ownerAddress, ',', '.'), 3) ,
PARSENAME(replace (ownerAddress, ',', '.'), 2) ,
PARSENAME(replace (ownerAddress, ',', '.'), 1)
From PortfolioProject..NashvilleHousing



Alter Table dbo.NashvilleHousing
add OwnerSplitAddress nvarchar(255);

update dbo.NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace (ownerAddress, ',', '.'), 3) 

Alter Table dbo.NashvilleHousing
add OwnerSplitCity nvarchar(255)

update dbo.NashvilleHousing
set OwnerSplitCity = PARSENAME(replace (ownerAddress, ',', '.'), 2) ,

Alter Table dbo.NashvilleHousing
add OwnerSplitState nvarchar(255)

update dbo.NashvilleHousing
set OwnerSplitState = PARSENAME(replace (ownerAddress, ',', '.'), 1)


Select*
From PortfolioProject..NashvilleHousing


--------------------------------------------------------------------------------------------------------------------
--Change Y and N to Yes and No in "Sold as Vacant" field

select Distinct (soldasvacant), Count(SoldAsVacant)
from dbo.NashvilleHousing
group by soldasvacant


Select SoldasVacant,
CASE when soldasvacant = 'Y' then 'Yes'
     when soldasvacant = 'N' then 'No'
     else soldasvacant
     END
     From dbo.NashvilleHousing
    

update dbo.NashvilleHousing
SET SoldAsVacant = 
    CASE when soldasvacant = 'Y' then 'Yes'
         when soldasvacant = 'N' then 'No'
         else soldasvacant
         END


----------------------------------------------------------------------------------------------------

--Remove Duplicates


WITH RowNumCTE AS (
Select* ,
ROW_NUMBER() OVER (

PARTITION BY ParcelID,
             PropertyAddress,
             Saleprice,
             SaleDate,
             LegalReference
             ORDER BY UniqueID) AS row_num


from dbo.NashvilleHousing
--order by ParcelID
)
DELETE
From RowNumCTE
where row_num > 1
--order by PropertyAddress




WITH RowNumCTE AS (
Select* ,
ROW_NUMBER() OVER (

PARTITION BY ParcelID,
             PropertyAddress,
             Saleprice,
             SaleDate,
             LegalReference
             ORDER BY UniqueID) AS row_num


from dbo.NashvilleHousing
--order by ParcelID
)
SELECT *
From RowNumCTE
where row_num > 1
--order by PropertyAddress



-------------------------------------------------------------------------------------------------------

--Delete Unused Columns

SELECT *
FROM PortfolioProject..NashvilleHousing;

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN salesdateconverted;

ALTER TABLE dbo.NashvilleHousing
DROP COLUMN SaleDate










