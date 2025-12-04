@AccessControl.authorizationCheck: #MANDATORY
@Metadata.allowExtensions: true
@ObjectModel.sapObjectNodeType.name: 'ZSTUDENTS_DB'
@EndUserText.label: '###GENERATED Core Data Service Entity'
define root view entity ZR_STUDENTS_DB
  as select from ZSTUDENTS_DB
{
  key student_id as StudentID,
  full_name as FullName,
  age as Age,
  branch as Branch,
  email as Email,
  phone_number as PhoneNumber,
  cgpa as Cgpa,
  @Semantics.user.createdBy: true
  local_created_by as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at as LocalCreatedAt,
  @Semantics.user.localInstanceLastChangedBy: true
  local_last_changed_by as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at as LastChangedAt
}
