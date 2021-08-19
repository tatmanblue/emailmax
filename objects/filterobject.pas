// copyright (c) 2002 by microObjects inc.
//
// Emailmax source is distributed under the public
// domain license arrangements.  You are free to
// modify, edit, copy, delete, or redistribute
// the emailmax code as long as you 1) indemnify and
// hold harmless microObjects inc and its employees and
// owners from any and all liablity, directly or indirectly,
// related to the use, modification or distribution
// of this code 2) and make proper credit where
// applicable.

unit filterobject;

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, StdCtrls,
  Buttons, ExtCtrls, ComCtrls, basfoldr;

// =============================================================================

type
    TActionTypes = (atNone, atNormal, atIgnore, atToTrash, atDelete);
    TFilterTypes = (ftNone, ftContains, ftBegins, ftEnds);
    TFilterItem = class(TObject)
    private
        m_sAccount,
        m_sFilterText : String;
        m_nActionType : TActionTypes;
        m_nFilterType : TFilterTypes;
        m_bIgnoreCase : Boolean;
    protected
    public
       procedure SetActionTypeFromText(actionText : String);
       procedure SetFilterTypeFromText(filterText : String);

       function GetActionTypeAsText(): String;
       function GetFilterTypeAsText(): String;

       function FilterApplies(text : String): boolean;

    published
        property Account : String read m_sAccount write m_sAccount;
        property FilterText : String read m_sFilterText write m_sFilterText;
        property FilterType : TFilterTypes read m_nFilterType write m_nFilterType default ftContains;
        property ActionType : TActionTypes read m_nActionType write m_nActionType default atIgnore;
        property IgnoreCase : Boolean read m_bIgnoreCase write m_bIgnoreCase default FALSE;

   end;

// =============================================================================
type
   TFilterList = class(TBaseFolder)
   protected
       m_oCurrentlySelected : TFilterItem;
       procedure SetActiveIndex(newIndex : Integer); override;


   public
       constructor Create;
       procedure GetSubSet(accountName : String; var oList : TFilterList);
       procedure AddFromFilterObject(filterItem : TFilterItem);

       function FilterApplies(text : String) : TActionTypes;

   published
       property SelectedItem : TFilterItem read m_oCurrentlySelected write m_oCurrentlySelected;

   end;


// =============================================================================
// =============================================================================
implementation

uses
   eglobal;

// =============================================================================
// =============================================================================
function TFilterItem.FilterApplies(text : String): boolean;
var
   bRet : boolean;
   applyPos : Integer;
   filterStr, textStr : String;
begin
   bRet := false;
   if IgnoreCase = true then
   begin
       filterStr := UpperCase(FilterText);
       textStr := UpperCase(text);
   end
   else
   begin
       filterStr := FilterText;
       textStr := text;
   end;


   applyPos := Pos(filterStr, textStr);

   case FilterType Of
       ftContains:
       begin
           if applyPos > 0 then
               bRet := true;
       end;
       ftBegins:
       begin
           if applyPos = 1 then
               bRet := true;
       end;
       ftEnds:
       begin
           if (length(text) - length(FilterText)) = applyPos then
               bRet := true;
       end;
   end;

   FilterApplies := bRet;
end;

// =============================================================================
// =============================================================================
procedure TFilterItem.SetFilterTypeFromText(filterText : String);
begin
   if LowerCase(Trim(filterText)) = 'contains' then
       FilterType := ftContains
   else if LowerCase(Trim(filterText)) = 'begins' then
       FilterType := ftBegins
   else if LowerCase(Trim(filterText)) = 'ends' then
       FilterType := ftEnds
   else
       FilterType := ftNone;

end;


// =============================================================================
// =============================================================================
procedure TFilterItem.SetActionTypeFromText(actionText : String);
begin
   if Trim(actionText) = 'ignore' then
       ActionType := atIgnore
   else if Trim(actionText) = 'delete' then
       ActionType := atDelete
   else if Trim(actionText) = 'trash' then
       ActionType := atToTrash
   else
       ActionType := atNormal;

end;

// =============================================================================
// =============================================================================
function TFilterItem.GetActionTypeAsText(): String;
begin
   case ActionType Of
       atIgnore: GetActionTypeAsText := 'ignore';
       atToTrash: GetActionTypeAsText := 'trash';
       atDelete: GetActionTypeAsText := 'delete';
   end;

end;

// =============================================================================
// =============================================================================
function TFilterItem.GetFilterTypeAsText(): String;
begin
   case FilterType Of
       ftContains: GetFilterTypeAsText := 'contains';
       ftBegins: GetFilterTypeAsText := 'begins';
       ftEnds: GetFilterTypeAsText := 'ends';
   end;

end;

// =============================================================================
// =============================================================================
constructor TFilterList.Create;
begin
   inherited Create;
   MaxIndex := 5;
   m_oCurrentlySelected := NIL;
end;

// =============================================================================
// =============================================================================
// CHG 1.11.02
procedure TFilterList.SetActiveIndex(newIndex : Integer);
var
   filterStr : String;
begin
   inherited SetActiveIndex(newIndex);
   if m_oCurrentlySelected = NIL then
       m_oCurrentlySelected := TFilterItem.Create;

   if Not Assigned(m_oCurrentlySelected) then
      raise Exception.Create('The attempt to allocate m_oCurrentlySelected failed in TFilterList.SetActiveIndex');

   with m_oCurrentlySelected do
   begin
       filterStr := Strings[ActiveIndex];

       Account := g_oEmailFilters.GetElement(filterStr, g_cnAccount);
       FilterText := g_oEmailFilters.GetElement(filterStr, g_cnText);
       SetFilterTypeFromText(g_oEmailFilters.GetElement(filterStr, g_cnType));
       SetActionTypeFromText(g_oEmailFilters.GetElement(filterStr, g_cnAction));

       if UpperCase(Trim(g_oEmailFilters.GetElement(filterStr, g_cnCaseSensitive))) = 'Y' then
           IgnoreCase := true
       else
           IgnoreCase := false;
   end;
end;


// =============================================================================
// =============================================================================
procedure TFilterList.GetSubSet(accountName : String; var oList : TFilterList);
var
   arrayCount : Integer;
   filterStr, accountStr : String;
begin
   if Not Assigned(oList) then
      raise Exception.Create('oList not assigned in TFilterList.GetSubSet');

   for arrayCount := 0 to (Count - 1) do
   begin
       filterStr := Strings[arrayCount];
       accountStr := Trim(GetElement(filterStr, g_cnAccount));
       if accountStr = accountName then
           oList.Add(filterStr)
       else if g_csAllAccounts = accountStr then
           oList.Add(filterStr);
   end;
end;

// =============================================================================
// =============================================================================
procedure TFilterList.AddFromFilterObject(filterItem : TFilterItem);
var
   filterStr : String;
begin
   if Not Assigned(filterItem) then
      raise Exception.Create('filterItem not assigned in TFilterList.AddFromFilterObject');

   with filterItem do
   begin
       filterStr :=  Account + g_ccharDelimiter + ' ' +
                     FilterText + g_ccharDelimiter + ' ';

       case FilterType Of
           ftContains: filterStr := filterStr + ' contains ' + g_ccharDelimiter;
           ftBegins: filterStr := filterStr + ' begins ' + g_ccharDelimiter;
           ftEnds: filterStr := filterStr + ' ends ' + g_ccharDelimiter;
       else
           filterStr := filterStr + ' <NA1> ' + g_ccharDelimiter;
       end;

       case ActionType Of
           atIgnore: filterStr := filterStr + ' ignore ' + g_ccharDelimiter;
           atToTrash: filterStr := filterStr + ' trash ' + g_ccharDelimiter;
           atDelete: filterStr := filterStr + ' delete ' + g_ccharDelimiter;
       else
           filterStr := filterStr + ' <NA> ' + g_ccharDelimiter;
       end;

       if IgnoreCase = true then
           filterStr := filterStr + ' Y '
       else
           filterStr := filterStr + ' N ';

   end;

   AddRowToList(filterStr);
end;

// =============================================================================
// =============================================================================
function TFilterList.FilterApplies(text : String) : TActionTypes;
var
   nFilterCount : Integer;
begin
   FilterApplies := atNormal;

   // TODO...09.24.01 would be better to throw exception if
   // no filter is found to apply

   for nFilterCount := 0 to (Self.Count - 1) do
   begin
       ActiveIndex := nFilterCount;
       assert(SelectedItem <> NIL, 'SelectedItem in TFilterList.FilterApplies is NIL');
       if SelectedItem.FilterApplies(text) then
       begin
           FilterApplies := SelectedItem.ActionType;
           break;
       end;
   end;

end;

end.
