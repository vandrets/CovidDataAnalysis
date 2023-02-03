Select *
From PortfolioProject01..NashvilleHousing

/*1 Standardize date format*/
SELECT SaleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject01.dbo.NashvilleHousing

Alter Table PortfolioProject01..NashvilleHousing
Add SaleDateConverted Date;

Update PortfolioProject01..NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)


--POPULATE Property address

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject01.dbo.NashvilleHousing a
Join PortfolioProject01.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


Update a
Set PropertyAddress = isnull(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject01.dbo.NashvilleHousing a
Join PortfolioProject01.dbo.NashvilleHousing b
on a.ParcelID = b.ParcelID AND a.UniqueID <> b.UniqueID
where a.PropertyAddress is null


DELETE
From PortfolioProject01.dbo.NashvilleHousing 
where PropertyAddress is null




--Breaking out address in address,city,state

Select PropertyAddress
From PortfolioProject01..NashvilleHousing

SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address ,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as Address
From PortfolioProject01..NashvilleHousing

Alter Table PortfolioProject01..NashvilleHousing
Add PropertySplitAddress nvarchar(255);

Update PortfolioProject01..NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)

Alter Table PortfolioProject01..NashvilleHousing
Add PropertySplitCity nvarchar(255);

Update PortfolioProject01..NashvilleHousing
SET PropertySplitCity  = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)
From PortfolioProject01..NashvilleHousing

Alter Table PortfolioProject01..NashvilleHousing
Add OwnerSplitState nvarchar(255);

Update PortfolioProject01..NashvilleHousing
SET OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress, ',', '.'),1)

Alter Table PortfolioProject01..NashvilleHousing
Add OwnerSplitCity nvarchar(255);

Update PortfolioProject01..NashvilleHousing
SET OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress, ',', '.'),2)

Alter Table PortfolioProject01..NashvilleHousing
Add OwnerSplitAddress nvarchar(255);

Update PortfolioProject01..NashvilleHousing
SET OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress, ',', '.'),3)


Select *
From PortfolioProject01..NashvilleHousing






--Convert Y AND N into Yes or no in sold as vacant column
Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From PortfolioProject01..NashvilleHousing
Group by SoldAsVacant
Order by 2

Select 
Case when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant ='N' Then 'No'
	 ELSE SoldAsVacant
	 END
From PortfolioProject01..NashvilleHousing

Update PortfolioProject01..NashvilleHousing
SET SoldAsVacant = Case when SoldAsVacant = 'Y' Then 'Yes'
	 when SoldAsVacant ='N' Then 'No'
	 ELSE SoldAsVacant
	 END

Select Distinct(SoldAsVacant),Count(SoldAsVacant)
From PortfolioProject01..NashvilleHousing
Group by SoldAsVacant
Order by 2

--Remove Duplicates
WITH ROWNUMCTE as(
Select *,
	ROW_NUMBER() OVER (Partition By ParcelID,
					PropertyAddress,
					SalePrice,SaleDate,
					LegalReference
					Order BY uniqueID) ROWNUM	
From PortfolioProject01..NashvilleHousing
)
Delete 
From ROWNUMCTE
Where ROWNUM >1


Select *
From PortfolioProject01..NashvilleHousing




-- Delete unused columns

Select *
From PortfolioProject01..NashvilleHousing

ALTER TABLE PortfolioProject01..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

ALTER TABLE PortfolioProject01..NashvilleHousing
DROP COLUMN SaleDate