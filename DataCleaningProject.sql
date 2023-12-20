SELECT *
FROM DataCleaningProject.dbo.NashvilleHousingData;

-- standarize date format

SELECT CONVERT(date,SaleDate)
FROM DataCleaningProject.dbo.NashvilleHousingData;

UPDATE NashvilleHousingData
SET SaleDate = CONVERT(date,SaleDate);

-- populate property adress data

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM DataCleaningProject.dbo.NashvilleHousingData a
JOIN DataCleaningProject.dbo.NashvilleHousingData b
	ON a.parcelid = b.parcelid
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null;

update a
SET a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM DataCleaningProject.dbo.NashvilleHousingData a
JOIN DataCleaningProject.dbo.NashvilleHousingData b
	ON a.parcelid = b.parcelid
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress is null;

-- breaking out adress into individual columns (adress, city, state)

SELECT PropertyAddress
FROM DataCleaningProject.dbo.NashvilleHousingData;

SELECT SUBSTRING(PropertyAddress, 1, CHARINDEX('.', PropertyAddress)) as Address
,SUBSTRING(PropertyAddress, CHARINDEX('.', PropertyAddress) + 1 , LEN(PropertyAddress)) as City
FROM DataCleaningProject.dbo.NashvilleHousingData; 

ALTER TABLE DataCleaningProject.dbo.NashvilleHousingData
ADD PropertySplitAddress varchar(50), PropertySplitCity  varchar(50);

UPDATE DataCleaningProject.dbo.NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX('.', PropertyAddress))
,PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX('.', PropertyAddress) + 1 , LEN(PropertyAddress));


SELECT OwnerAddress
FROM DataCleaningProject.dbo.NashvilleHousingData
WHERE OwnerAddress is not null;

SELECT PARSENAME(OwnerAddress, 3)
,PARSENAME(OwnerAddress, 2)
,PARSENAME(OwnerAddress, 1)
FROM DataCleaningProject.dbo.NashvilleHousingData
WHERE OwnerAddress is not null;

ALTER TABLE DataCleaningProject.dbo.NashvilleHousingData
ADD OwnerSplitAddress varchar(50)
, OwnerSplitCity varchar(50)
, OwnerSplitState varchar(50);

UPDATE DataCleaningProject.dbo.NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(OwnerAddress, 3)
, OwnerSplitCity = PARSENAME(OwnerAddress, 2)
, OwnerSplitState = PARSENAME(OwnerAddress, 1);

-- change Y and N yo Yes and No in "Sold as vacant" field -- PROBLEMS

SELECT SoldAsVacant 
FROM DataCleaningProject.dbo.NashvilleHousingData;

-- remove duplicates

-- delete unused columns