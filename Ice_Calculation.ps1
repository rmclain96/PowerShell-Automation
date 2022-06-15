<#
.SYNOPSIS  
    Verifies your final answer by intaking the given information provided to solve the ICE chart
.DESCRIPTION  
    ICE stands for I nitial, C hange, E quilibrium. An ICE table is a tool used to calculate the changing concentrations of reactants and products in (dynamic) equilibrium reactions.
    Verifies your final answer by intaking the given information provided to solve the ICE chart: Will remain unfinished due to priority change
.NOTES  
    File Name  : Ice_Calculation.ps1  
    Author     : Ryan
    Requires   : PowerShell 5.1 (Maybe)
    Date last revised: 10/15/2021

///////////////////////////////////////////////////////////////////
//                    //                    //                   //
// Initial_Reactant_1 // Initial_Reactant_2 //  Initial_Product  //
//                    //                    //                   //          
///////////////////////////////////////////////////////////////////
//                    //                    //                   //
//      Change_1      //      Change_2      //     Change_3      //
//                    //                    //                   //          
///////////////////////////////////////////////////////////////////
//                    //                    //                   //
//   Equilibrium_1    //   Equilibrium_2    //   Equilibrium_3   //
//                    //                    //                   //           
///////////////////////////////////////////////////////////////////

#>

#If a value does not exist, you must still press enter
Param(
    [Parameter(Mandatory=$True)]
    [Double]$Rate_Constant,
    [Parameter(Mandatory=$True)]
    [Double]$Initial_Reactant_1,
    [Parameter(Mandatory=$True)]
    [Double]$Initial_Reactant_2,
    [Parameter(Mandatory=$True)]
    [Double]$Initial_Product,
    [Parameter(Mandatory=$False)]
    [Double]$Equilibrium_One = $Null,
    [Parameter(Mandatory=$False)]
    [Double]$Equilibrium_Two = $Null,
    [Parameter(Mandatory=$False)]
    [Double]$Equilibrium_Three = $Null,
    [Parameter(Mandatory=$True)]
    [Double]$Equilibrium_Provided,
    [Parameter(Mandatory=$True)]
    [Double]$Coefficient_P,
    [Parameter(Mandatory=$True)]
    [Double]$Coefficient_R
)

If (!($Coefficient_P)){
    $Coefficient_P = 1
}
If (!($Coefficient_R)){
    $Coefficient_R = 1
}

#Prompt the user for equilibrium value
[INT]$Equilibrium_Number = Read-Host -Prompt "Is the equilibrium value for column 1, 2, or 3"

Switch($Equilibrium_Number) {
    1 {$Equilibrium_One = $Equilibrium_Provided}
    2 {$Equilibrium_Two = $Equilibrium_Provided}
    3 {$Equilibrium_Three = $Equilibrium_Provided}
}

#Bottom FOIL to get (ax^2 +bx +c)
#First (c)
$Bottom_First = $Initial_Reactant_1 * $Initial_Reactant_2
#Inside + Outside (bx)
$Bottom_In_Out = $Initial_Reactant_1 + $Initial_Reactant_2 
#Last for foil, always be x^2 (ax^2)
$Bottom_Last = 1

#Multiply all bottom values by Rate Constant
$C = $Bottom_First * $Rate_Constant
$B = $Bottom_In_Out * $Rate_Constant
$A = $Bottom_Last * $Rate_Constant

#Top when the product IV is 0, it must be negative coefficient
if ($Initial_Product -eq 0){
    $Top = [Math]::Pow($Coefficient_P,2)
}Else{
    $Top = [Math]::Pow(($Coefficient_P) * ($Initial_Product), 2)
}

#Subtract the top by x^2 or x
If ($Coefficient_P -eq 1){
    $BValue = $B - $Top
    $AValue = $A
}Else{
    $AValue = $A - $Top
    $BValue = $B
}

#Ax^2 + Bx + C
#input into quadratic formula
$QuadTop = [Math]::Pow($BValue,2) - (4 * ($AValue * $C))
$QuadTopFinal = [math]::Sqrt($QuadTop)

#-B + or - shananigans
$Quadratic1 = -($BValue + $QuadTopFinal) / (2 * $AValue)
$Quadratic2 = -($BValue - $QuadTopFinal) / (2 * $AValue)
