import serverly/params

echo "Starting is_templated test. All following messages should be true"
echo "/item/1".isTemplated("/item/:id")
echo not "/item/".isTemplated("/item/:id")
echo not "/item/1".isTemplated("/item/")
echo "/item/1/2".isTemplated("/item/:id/:od")
echo not "/item/1/2".isTemplated("/item/:id")
echo not "/item/1".isTemplated("/item/:id/:od")

echo "Starting getParamsFromString test"
echo "/item/1"
echo "/item/1".getParamsFromString("/item/:id")
echo "/item/1/2"
echo "/item/1/2".getParamsFromString("/item/:id/:od")

echo "Starting getQueryParams test"
echo "a=10"
echo "a=10".getQueryParams()
echo "a=10&b=5"
echo "a=10&b=5".getQueryParams()