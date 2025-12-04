CLASS LHC_ZR_STUDENTS_DB DEFINITION INHERITING FROM CL_ABAP_BEHAVIOR_HANDLER.
  PRIVATE SECTION.
    METHODS:
      GET_GLOBAL_AUTHORIZATIONS FOR GLOBAL AUTHORIZATION
        IMPORTING
           REQUEST requested_authorizations FOR ZrStudentsDb
        RESULT result,
      checkuniqueness FOR VALIDATE ON SAVE
            IMPORTING keys FOR ZrStudentsDb~checkUniqueness,
      formatName FOR DETERMINE ON MODIFY
            IMPORTING keys FOR ZrStudentsDb~formatName,
      GenerateEmail FOR DETERMINE ON MODIFY
            IMPORTING keys FOR ZrStudentsDb~GenerateEmail.
ENDCLASS.

CLASS LHC_ZR_STUDENTS_DB IMPLEMENTATION.
  METHOD GET_GLOBAL_AUTHORIZATIONS.
  ENDMETHOD.


METHOD checkuniqueness.

      DATA currentRecords TYPE TABLE FOR READ RESULT ZR_STUDENTS_DB.
      DATA reportedRecord LIKE LINE OF reported-zrstudentsdb.
*      DATA existingRecords TYPE TABLE FOR READ RESULT ZR_STUDENTS_DB.

      READ ENTITIES OF ZR_STUDENTS_DB IN LOCAL MODE
        ENTITY ZrStudentsDb
          FIELDS ( studentid email phoneNumber )
          WITH CORRESPONDING #( keys )
          RESULT currentRecords.


      LOOP AT currentRecords INTO DATA(record).
        SELECT FROM ZR_STUDENTS_DB
            FIELDS studentid,email,phoneNumber
            WHERE ( studentid <> @record-StudentID AND
                    email = @record-Email ) OR
                  ( studentid <> @record-StudentID AND
                    phoneNumber = @record-PhoneNumber )

            INTO TABLE @DATA(existingRecords).
      READ TABLE existingRecords INTO DATA(existing) INDEX 1.
      IF existingRecords IS NOT INITIAL.
        DATA(message) = me->new_message(
                            id = 'Z_STUD_MESSAGE_CLASS'
                            number = '001'
                            severity = ms-error
                        ).


        reportedRecord-%tky = record-%tky.
        reportedRecord-%msg = message.
        IF record-email = existing-Email.
            reportedRecord-%element-email = if_abap_behv=>mk-on.
        ELSEIF existing-phoneNumber = record-phoneNumber.
            reportedRecord-%element-phoneNumber = if_abap_behv=>mk-on.
        ENDIF.

          APPEND reportedRecord TO reported-zrstudentsdb.

      ENDIF.

      ENDLOOP.



ENDMETHOD.

  METHOD formatName.
    READ ENTITIES OF ZR_STUDENTS_DB IN LOCAL MODE
         ENTITY ZrStudentsDb
         FIELDS ( fullname )
         WITH CORRESPONDING #( keys )
         RESULT DATA(changedRecords).
    IF changedRecords IS INITIAL.
        RETURN.
    ENDIF.
*   changedRecords is an internal table of derived type FOR READ RESULT containing
*   the records having field 'fullname' for all the records with the keys specified by the implicit parameter
    DATA formattedNames TYPE TABLE FOR UPDATE ZR_STUDENTS_DB.

    LOOP AT changedRecords INTO DATA(changedRecord).
        DATA(original)  = changedRecord-fullname.
        DATA(formatted) = ``.
        SPLIT original AT space INTO TABLE DATA(name_parts).

        " 2. Loop through every part (e.g., 'john', 'doe')
        LOOP AT name_parts ASSIGNING FIELD-SYMBOL(<part>).
          " Force lowercase first to clean up (e.g., 'JOHN' -> 'john')
          <part> = to_lower( <part> ).

          " Capitalize only the first letter
          IF <part> IS NOT INITIAL.
             <part> = |{ to_upper( <part>(1) ) }{ substring( val = <part> off = 1 ) }|.
          ENDIF.
        ENDLOOP.

        " 3. Join them back together with spaces
        formatted = concat_lines_of( table = name_parts sep = ` ` ).



        " GUARD: if already formatted -> skip (prevents recursion)
        IF original = formatted.
          CONTINUE.
        ENDIF.

        " apply and update the internal table
        changedRecord-fullname = formatted.
        APPEND VALUE #(
          %tky     = changedRecord-%tky
          fullname = formatted
        ) TO formattedNames.

    ENDLOOP.


    IF formattedNames IS INITIAL.
      RETURN. "nothing to update
    ENDIF.

    MODIFY ENTITIES OF ZR_STUDENTS_DB IN LOCAL MODE
        ENTITY ZrStudentsDb
        UPDATE
        FIELDS ( fullname )
        WITH formattedNames.


  ENDMETHOD.

  METHOD GenerateEmail.

    DATA generatedEmails TYPE TABLE FOR UPDATE ZR_STUDENTS_DB.

    READ ENTITIES OF ZR_STUDENTS_DB IN LOCAL MODE
    ENTITY ZrStudentsDb
    FIELDS ( email studentID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(changedRecords).




    LOOP AT changedRecords INTO DATA(changedRecord).
        IF changedRecord-Email IS INITIAL.
            changedRecord-Email = '22WJ8A' && changedRecord-StudentID && '@gniindia.org'.
        ENDIF.

        APPEND VALUE #(
            %tky = changedRecord-%tky
            email = changedRecord-Email
         ) TO generatedEmails.
    ENDLOOP.

    IF generatedEmails IS INITIAL.
        RETURN.
    ENDIF.

    MODIFY ENTITIES OF ZR_STUDENTS_DB IN LOCAL MODE
        ENTITY ZrStudentsDb
        UPDATE
        FIELDS ( email )
        WITH generatedEmails.

  ENDMETHOD.

ENDCLASS.
