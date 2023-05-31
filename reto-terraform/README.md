#Reto Terraform

Hay que dividir lo que podamos en lo máximo posible el main.tf, en módulos

#Modulos ejemplo (hay que cambiar el nombre de los módulos y ponerlo con los módulos que queramos)

module "network" {
    source = "./m1"
}

#Vars 

En los archivos vars.tf tenemos únicamente que declarar variables

#.tfvars

Los archivos .tfvars tenemos que crear 3 diferentes cambiando las zonas o cualquier cosa para cuando pasemos los comandos se pueda hacer bien