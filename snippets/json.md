好的，我为你创建了更全面的 **C/C++ 版本** 和 **Java 版本**，包含了更多常用的返回类型和变体。

---

## 📌 C/C++ 版本 (`c.json` / `cpp.json`)

```json
{
  // ==================== 基础返回类型 ====================
  "F - Void Function": {
    "prefix": "Fv",
    "body": ["void ${1:function_name}(${2:parameters}) {", "\t$0", "}"],
    "description": "C/C++ void function"
  },
  "F - Int Function": {
    "prefix": "Fi",
    "body": [
      "int ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:0};",
      "}"
    ],
    "description": "C/C++ int function"
  },
  "F - Char Function": {
    "prefix": "Fc",
    "body": [
      "char ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:'\\\\0'};",
      "}"
    ],
    "description": "C/C++ char function"
  },
  "F - Float Function": {
    "prefix": "Ff",
    "body": [
      "float ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:0.0f};",
      "}"
    ],
    "description": "C/C++ float function"
  },
  "F - Double Function": {
    "prefix": "Fd",
    "body": [
      "double ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:0.0};",
      "}"
    ],
    "description": "C/C++ double function"
  },
  "F - Bool Function": {
    "prefix": "Fbool",
    "body": [
      "bool ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:false};",
      "}"
    ],
    "description": "C/C++ bool function"
  },

  // ==================== 指针类型 ====================
  "F - Int* Function": {
    "prefix": "Fip",
    "body": [
      "int* ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:nullptr};",
      "}"
    ],
    "description": "C/C++ int* function"
  },
  "F - Char* Function": {
    "prefix": "Fcp",
    "body": [
      "char* ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:nullptr};",
      "}"
    ],
    "description": "C/C++ char* function"
  },
  "F - Void* Function": {
    "prefix": "Fvp",
    "body": [
      "void* ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:nullptr};",
      "}"
    ],
    "description": "C/C++ void* function"
  },

  // ==================== 整数变体 ====================
  "F - Short Function": {
    "prefix": "Fshort",
    "body": [
      "short ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:0};",
      "}"
    ],
    "description": "C/C++ short function"
  },
  "F - Long Function": {
    "prefix": "Fl",
    "body": [
      "long ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:0L};",
      "}"
    ],
    "description": "C/C++ long function"
  },
  "F - Long Long Function": {
    "prefix": "Fll",
    "body": [
      "long long ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:0LL};",
      "}"
    ],
    "description": "C/C++ long long function"
  },
  "F - Unsigned Int Function": {
    "prefix": "Fui",
    "body": [
      "unsigned int ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:0u};",
      "}"
    ],
    "description": "C/C++ unsigned int function"
  },
  "F - Size_t Function": {
    "prefix": "Fsize",
    "body": [
      "size_t ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:0};",
      "}"
    ],
    "description": "C/C++ size_t function"
  },

  // ==================== C++ 特定 ====================
  "F - std::string Function": {
    "prefix": "Fstr",
    "body": [
      "std::string ${1:function_name}(${2:parameters}) {",
      "\t$0",
      "\treturn ${3:\"\"};",
      "}"
    ],
    "description": "C++ std::string function"
  },
  "F - std::vector Function": {
    "prefix": "Fvec",
    "body": [
      "std::vector<${1:T}> ${2:function_name}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:{}};",
      "}"
    ],
    "description": "C++ std::vector function"
  },
  "F - std::unique_ptr Function": {
    "prefix": "Fup",
    "body": [
      "std::unique_ptr<${1:T}> ${2:function_name}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:nullptr};",
      "}"
    ],
    "description": "C++ std::unique_ptr function"
  },
  "F - std::shared_ptr Function": {
    "prefix": "Fsp",
    "body": [
      "std::shared_ptr<${1:T}> ${2:function_name}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:nullptr};",
      "}"
    ],
    "description": "C++ std::shared_ptr function"
  },

  // ==================== 特殊变体 ====================
  "F - Static Function": {
    "prefix": "Fs",
    "body": [
      "static ${1:void} ${2:function_name}(${3:parameters}) {",
      "\t$0",
      "}"
    ],
    "description": "C/C++ static function"
  },
  "F - Inline Function": {
    "prefix": "Finline",
    "body": [
      "inline ${1:void} ${2:function_name}(${3:parameters}) {",
      "\t$0",
      "}"
    ],
    "description": "C/C++ inline function"
  },
  "F - Const Function (C++)": {
    "prefix": "Fconst",
    "body": [
      "${1:void} ${2:function_name}(${3:parameters}) const {",
      "\t$0",
      "}"
    ],
    "description": "C++ const member function"
  },
  "F - Noexcept Function (C++)": {
    "prefix": "Fnoexcept",
    "body": [
      "${1:void} ${2:function_name}(${3:parameters}) noexcept {",
      "\t$0",
      "}"
    ],
    "description": "C++ noexcept function"
  },

  // ==================== 通用模板 ====================
  "F - Custom Function": {
    "prefix": "F",
    "body": [
      "${1:return_type} ${2:function_name}(${3:parameters}) {",
      "\t$0",
      "}"
    ],
    "description": "C/C++ custom function (F + type)"
  }
}
```

---

## ☕ Java 版本 (`java.json`)

```json
{
  // ==================== 基础返回类型 ====================
  "F - Void Method": {
    "prefix": "Fv",
    "body": [
      "${1:private} void ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "}"
    ],
    "description": "Java void method"
  },
  "F - Int Method": {
    "prefix": "Fi",
    "body": [
      "${1:private} int ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:0};",
      "}"
    ],
    "description": "Java int method"
  },
  "F - String Method": {
    "prefix": "Fs",
    "body": [
      "${1:private} String ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:\"\"};",
      "}"
    ],
    "description": "Java String method"
  },
  "F - Boolean Method": {
    "prefix": "Fb",
    "body": [
      "${1:private} boolean ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:false};",
      "}"
    ],
    "description": "Java boolean method"
  },
  "F - Char Method": {
    "prefix": "Fc",
    "body": [
      "${1:private} char ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:'\\\\0'};",
      "}"
    ],
    "description": "Java char method"
  },
  "F - Double Method": {
    "prefix": "Fd",
    "body": [
      "${1:private} double ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:0.0};",
      "}"
    ],
    "description": "Java double method"
  },
  "F - Float Method": {
    "prefix": "Ff",
    "body": [
      "${1:private} float ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:0.0f};",
      "}"
    ],
    "description": "Java float method"
  },
  "F - Long Method": {
    "prefix": "Fl",
    "body": [
      "${1:private} long ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:0L};",
      "}"
    ],
    "description": "Java long method"
  },

  // ==================== 包装类型 ====================
  "F - Integer Method": {
    "prefix": "FInteger",
    "body": [
      "${1:private} Integer ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:null};",
      "}"
    ],
    "description": "Java Integer method"
  },
  "F - Boolean (Object) Method": {
    "prefix": "FBoolObj",
    "body": [
      "${1:private} Boolean ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:null};",
      "}"
    ],
    "description": "Java Boolean (Object) method"
  },

  // ==================== 集合类型 ====================
  "F - List Method": {
    "prefix": "Flist",
    "body": [
      "${1:private} List<${2:T}> ${3:methodName}(${4:parameters}) {",
      "\t$0",
      "\treturn ${5:null};",
      "}"
    ],
    "description": "Java List<T> method"
  },
  "F - ArrayList Method": {
    "prefix": "Farraylist",
    "body": [
      "${1:private} ArrayList<${2:T}> ${3:methodName}(${4:parameters}) {",
      "\t$0",
      "\treturn ${5:new ArrayList<>()};",
      "}"
    ],
    "description": "Java ArrayList<T> method"
  },
  "F - Map Method": {
    "prefix": "Fmap",
    "body": [
      "${1:private} Map<${2:K}, ${3:V}> ${4:methodName}(${5:parameters}) {",
      "\t$0",
      "\treturn ${6:null};",
      "}"
    ],
    "description": "Java Map<K, V> method"
  },
  "F - HashMap Method": {
    "prefix": "Fhashmap",
    "body": [
      "${1:private} HashMap<${2:K}, ${3:V}> ${4:methodName}(${5:parameters}) {",
      "\t$0",
      "\treturn ${6:new HashMap<>()};",
      "}"
    ],
    "description": "Java HashMap<K, V> method"
  },
  "F - Set Method": {
    "prefix": "Fset",
    "body": [
      "${1:private} Set<${2:T}> ${3:methodName}(${4:parameters}) {",
      "\t$0",
      "\treturn ${5:null};",
      "}"
    ],
    "description": "Java Set<T> method"
  },
  "F - Optional Method": {
    "prefix": "Fopt",
    "body": [
      "${1:private} Optional<${2:T}> ${3:methodName}(${4:parameters}) {",
      "\t$0",
      "\treturn ${5:Optional.empty()};",
      "}"
    ],
    "description": "Java Optional<T> method"
  },

  // ==================== 数组类型 ====================
  "F - Int Array Method": {
    "prefix": "Fiarr",
    "body": [
      "${1:private} int[] ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:null};",
      "}"
    ],
    "description": "Java int[] method"
  },
  "F - String Array Method": {
    "prefix": "Fsarr",
    "body": [
      "${1:private} String[] ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "\treturn ${4:null};",
      "}"
    ],
    "description": "Java String[] method"
  },

  // ==================== 访问修饰符变体 ====================
  "F - Public Method": {
    "prefix": "Fpub",
    "body": [
      "public ${1:void} ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "}"
    ],
    "description": "Java public method"
  },
  "F - Protected Method": {
    "prefix": "Fpro",
    "body": [
      "protected ${1:void} ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "}"
    ],
    "description": "Java protected method"
  },
  "F - Private Method": {
    "prefix": "Fpri",
    "body": [
      "private ${1:void} ${2:methodName}(${3:parameters}) {",
      "\t$0",
      "}"
    ],
    "description": "Java private method"
  },

  // ==================== 特殊修饰符 ====================
  "F - Static Method": {
    "prefix": "Fstatic",
    "body": [
      "${1:private} static ${2:void} ${3:methodName}(${4:parameters}) {",
      "\t$0",
      "}"
    ],
    "description": "Java static method"
  },
  "F - Final Method": {
    "prefix": "Ffinal",
    "body": [
      "${1:private} final ${2:void} ${3:methodName}(${4:parameters}) {",
      "\t$0",
      "}"
    ],
    "description": "Java final method"
  },
  "F - Abstract Method": {
    "prefix": "Fabstract",
    "body": [
      "${1:public} abstract ${2:void} ${3:methodName}(${4:parameters});"
    ],
    "description": "Java abstract method"
  },
  "F - Synchronized Method": {
    "prefix": "Fsync",
    "body": [
      "${1:private} synchronized ${2:void} ${3:methodName}(${4:parameters}) {",
      "\t$0",
      "}"
    ],
    "description": "Java synchronized method"
  },

  // ==================== 异常相关 ====================
  "F - Method with Throws": {
    "prefix": "Fthrow",
    "body": [
      "${1:private} ${2:void} ${3:methodName}(${4:parameters}) throws ${5:Exception} {",
      "\t$0",
      "}"
    ],
    "description": "Java method with throws"
  },

  // ==================== 构造函数 ====================
  "F - Constructor": {
    "prefix": "Fctor",
    "body": ["public ${1:ClassName}(${2:parameters}) {", "\t$0", "}"],
    "description": "Java constructor"
  },
  "F - Constructor with Super": {
    "prefix": "Fctorsuper",
    "body": [
      "public ${1:ClassName}(${2:parameters}) {",
      "\tsuper(${3:super_params});",
      "\t$0",
      "}"
    ],
    "description": "Java constructor with super()"
  },

  // ==================== Getter/Setter ====================
  "F - Getter": {
    "prefix": "Fget",
    "body": [
      "public ${1:Type} get${2:FieldName}() {",
      "\treturn ${3:field};",
      "}"
    ],
    "description": "Java getter method"
  },
  "F - Setter": {
    "prefix": "Fset",
    "body": [
      "public void set${1:FieldName}(${2:Type} ${3:field}) {",
      "\tthis.${3:field} = ${3:field};",
      "}"
    ],
    "description": "Java setter method"
  },

  // ==================== 通用模板 ====================
  "F - Custom Method": {
    "prefix": "F",
    "body": [
      "${1:private} ${2:return_type} ${3:methodName}(${4:parameters}) {",
      "\t$0",
      "}"
    ],
    "description": "Java custom method (F + type)"
  }
}
```

---

## 📋 快速参考表

### C/C++ 前缀速查

| 前缀    | 返回类型           |
| ------- | ------------------ |
| `F`     | 自定义类型         |
| `Fv`    | void               |
| `Fi`    | int                |
| `Fc`    | char               |
| `Ff`    | float              |
| `Fd`    | double             |
| `Fbool` | bool               |
| `Fstr`  | std::string        |
| `Fvec`  | std::vector<T>     |
| `Fup`   | std::unique_ptr<T> |
| `Fsp`   | std::shared_ptr<T> |

### Java 前缀速查

| 前缀    | 返回类型    |
| ------- | ----------- |
| `F`     | 自定义类型  |
| `Fv`    | void        |
| `Fi`    | int         |
| `Fs`    | String      |
| `Fb`    | boolean     |
| `Flist` | List<T>     |
| `Fmap`  | Map<K, V>   |
| `Fopt`  | Optional<T> |
| `Fget`  | Getter      |
| `Fset`  | Setter      |
| `Fctor` | 构造函数    |

将对应的 JSON 内容复制到你的语言片段文件中即可使用！
