select * from NashvilleHousing; 

 --standardize date format
 
 select saledate,convert(date,saledate)
 from NashvilleHousing;

 update NashvilleHousing
set saledate= convert(date,SaleDate);

--populate property address date

select * from NashvilleHousing
 --where propertyaddress is null
 order by parcelid

 select a.parcelid,a.propertyaddress,b.parcelid,b.propertyaddress
 from NashvilleHousing a
 join NashvilleHousing b
 on a.parcelid=b.parcelid
 and a.uniqueid<>b.uniqueId
 where a.propertyaddress is null;

 update a
 set propertyaddress=isnull(a.propertyaddress,b.propertyaddress)
 from NashvilleHousing a
 join NashvilleHousing b
 on a.parcelid=b.parcelid
 and a.uniqueid<>b.uniqueId
  where a.propertyaddress is null;


--Breaking address into individual columns(address,city,state)
  --propertyaddress

select propertyaddress from nashvillehousing;

select 
substring(propertyaddress,1, charindex(',',propertyaddress)-1) as address,
substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress)) as address
from nashvillehousing;

alter table nashvillehousing
add propertysplitaddress nvarchar(255);

update nashvillehousing
set propertysplitaddress = substring(propertyaddress,1, charindex(',',propertyaddress)-1);

alter table nashvillehousing
add propertysplitcity nvarchar(255);

update nashvillehousing
set propertysplitcity = substring(propertyaddress,charindex(',',propertyaddress)+1,len(propertyaddress));


  --owner address

  select 
  parsename(replace(owneraddress,',','.'),3),
   parsename(replace(owneraddress,',','.'),2),
    parsename(replace(owneraddress,',','.'),1)
	from nashvillehousing;

alter table nashvillehousing
add onwersplitaddress nvarchar(255);

update nashvillehousing
set onwersplitaddress = parsename(replace(owneraddress,',','.'),3);

alter table nashvillehousing
add ownersplitcity nvarchar(255);

update nashvillehousing
set ownersplitcity = parsename(replace(owneraddress,',','.'),2);

alter table nashvillehousing
add ownersplitstate  nvarchar(255);

update nashvillehousing
set ownersplitstate = parsename(replace(owneraddress,',','.'),1);

--change Y and N into yes and No in sold as vacant field

select soldasvacant, 
case when soldasvacant='y' then 'yes' 
     when soldasvacant='n' then 'NO'
	 else soldasvacant end
	 from nashvillehousing;

update NashvilleHousing
set soldasvacant=case when soldasvacant='y' then 'yes' 
     when soldasvacant='n' then 'NO'
	 else soldasvacant end;

--Remove duplicates
with rownumcte as(
select *,
  row_number() over(
  partition by parcelid,propertyaddress,saleprice,saledate,legalreference
  order by uniqueid)row_num
  from nashvillehousing
  --order by ParcelID;
)

delete from rownumcte
  where row_num>1


  --Delete unused columns

  select * from nashvillehousing



