@AbapCatalog.sqlViewName: 'ZVHVBRANCH'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'View help for Students Branch'
@Metadata.ignorePropagatedAnnotations: true
define view ZVH_BRANCH as select from zbranches
{
    key branch as Branch,
    branchtext  as BranchText   
}
