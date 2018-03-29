# Default build args, not needed to set when building, unless using a external SQL server

# Install SIF

# Add the Sitecore MyGet repository to PowerShell
Register-PSRepository -Name SitecoreGallery -SourceLocation https://sitecore.myget.org/F/sc-powershell/api/v2 

# # Install the Sitecore Install Framwork module
Install-Module SitecoreInstallFramework

# # Install the Sitecore Fundamentals module (provides additional functionality for local installations like creating self-signed certificates)
Install-Module SitecoreFundamentals

    
# # Import the modules into your current PowerShell context (if necessary)
Import-Module SitecoreFundamentals
Import-Module SitecoreInstallFramework

#define parameters
$version = "8.2 rev. 171121"
$PSScriptRootsitecore = (Get-Item -Path ".\" -Verbose).FullName
$files = Join-Path -path $PSScriptRootsitecore -childpath "Files\$version\"
$modules = Join-Path -path $PSScriptRootsitecore -childpath "Files\Modules\"
$buildTarget = "Build"

$prefix = "wsf-master-oap"
$sitecoreSiteName = "$prefix"

$SolrUrl = "https://localhost:8983/solr"
$SolrRoot = "C:solr-6.6.2"
$SolrService = "solr662"

$SqlServer = "Data Source=.\\SQLEXPRESS;User ID=sa;password=sa;Database="

#install solr cores for xdb 
$solrParams = 
@{
    Path = "$PSScriptRootxconnect-solr.json"     
    SolrUrl = $SolrUrl    
    SolrRoot = $SolrRoot  
    SolrService = $SolrService  
    CorePrefix = $prefix 
} 
#Install-SitecoreConfiguration @solrParams -Verbose

if(!(Test-Path -Path $buildTarget )){
    New-Item -ItemType directory -Path $buildTarget
}

$sitecoreParams = 
@{     
    Path = "$($PSScriptRootsitecore)\\config\xp-sitecore-cm-82-171121-ps472-sxa16.json"
    Package = "$($files)Sitecore 8.2 rev. 171121_single.scwdp.zip" 
    Package_Powershell = "$($modules)Sitecore PowerShell Extensions-4.7.2 for Sitecore 8.scwdp.zip" 
    Package_SXA = "$($modules)Sitecore Experience Accelerator 1.6 rev. 180103 for 8.2.scwdp.zip" 
    InstallDirectory = $buildTarget 
    LicenseFile = "$($files)license.xml"
    SqlDbPrefix = $sitecoreSiteName  
    SqlServer = $SqlServer  
    SolrCorePrefix = $prefix  
    SolrUrl = $SolrUrl     
    Sitename = $sitecoreSiteName
} 
Install-SitecoreConfiguration @sitecoreParams -Verbose