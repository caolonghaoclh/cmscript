# Introduction
this template aims to construct a library which consists of multiple independent modules,</br>
however part of these modules exist mutual dependence.In order to achieve this purpose, we may</br>
use the command "add_subdirectory" at the top level CMakeLists.txt to find all modules. below each </br>
module, we code specific scripts to generate libraries the module supports.last of all, we come back </br>
to the top level region, and all targets have been generated at this time. the last thing we need to do</br>
is to install and export all targets.well, this template will works good for this solution.
# Caution
* this solution not depends on cmscript, but their objective is the same
* this solution supports additional script files to find LASTools and Gperftools
# Important Knowledge
* when we use the command "add_subdirectory", the variables defined under the submodules can not be delivered</br>
to the parent level scope simplely.because, what we need to deliver is a list variable which expresses the </br>
targets exported. I had tried some methods by defining global string variable, but they not work perfectly. </br>
afterward I realize that a list variable can be deemed as a special string variable. On the other hand, a list </br>
variable is equal to a long string which consists of multiple strings and is splited by the symbol ";"</br>
so I use "set_properties/get_properties" to keep a global string variable which records all targets exported</br>
and deliver it to the command "list(APPEND" directly.
