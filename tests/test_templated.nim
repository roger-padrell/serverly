import serverly/params, unittest, tables

test "isTemplated":
    assert "/item/1".isTemplated("/item/:id")
    assert not "/item/".isTemplated("/item/:id")
    assert not "/item/1".isTemplated("/item/")
    assert "/item/1/2".isTemplated("/item/:id/:od")
    assert not "/item/1/2".isTemplated("/item/:id")
    assert not "/item/1".isTemplated("/item/:id/:od")

test "getParamsFromString (item parameters)":
    assert "/item/1".getParamsFromString("/item/:id") == {"id":"1"}.toTable()
    assert "/item/1/2".getParamsFromString("/item/:id/:od") == {"id":"1","od":"2"}.toTable()

test "getQueryParams":
    assert "a=10".getQueryParams() == {"a":"10"}.toTable()
    assert "a=10&b=5".getQueryParams() == {"a":"10","b":"5"}.toTable()