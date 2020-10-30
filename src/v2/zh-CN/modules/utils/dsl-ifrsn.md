IFRSN: Input Fields Relation Structured Notation，可结构化的输入字段及其关系表达式解析器。

## 基本语法格式

```
entity1(field1,field2{option1:param1,option2:param2},entity2(field11,field22, ...), ...)
```

## 示例

``` php
IFRSN::parse('category(id,title{a:32})');
```

## 应用

- GraphQLAlike
