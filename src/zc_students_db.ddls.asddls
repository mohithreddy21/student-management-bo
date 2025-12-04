@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@EndUserText: {
  label: '###GENERATED Core Data Service Entity'
}
@ObjectModel: {
  sapObjectNodeType.name: 'ZSTUDENTS_DB'
}
@AccessControl.authorizationCheck: #MANDATORY
define root view entity ZC_STUDENTS_DB
  provider contract transactional_query
  as projection on ZR_STUDENTS_DB
  association [1..1] to ZR_STUDENTS_DB as _BaseEntity on $projection.StudentID = _BaseEntity.StudentID
{
  key StudentID,
  FullName,
  Age,
  @Consumption.valueHelpDefinition: [{
      entity: {
        name: 'ZVH_BRANCH',
        element: 'Branch'
      }
  } ]
  Branch,
  Email,
  PhoneNumber,
  Cgpa,
  @Semantics: {
    user.createdBy: true
  }
  LocalCreatedBy,
  @Semantics: {
    systemDateTime.createdAt: true
  }
  LocalCreatedAt,
  @Semantics: {
    user.localInstanceLastChangedBy: true
  }
  LocalLastChangedBy,
  @Semantics: {
    systemDateTime.localInstanceLastChangedAt: true
  }
  LocalLastChangedAt,
  @Semantics: {
    systemDateTime.lastChangedAt: true
  }
  LastChangedAt,
  _BaseEntity
}
