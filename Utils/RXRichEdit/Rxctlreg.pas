{*******************************************************}
{                                                       }
{         Delphi VCL Extensions (RX)                    }
{                                                       }
{         Copyright (c) 1995, 1996 AO ROSNO             }
{         Copyright (c) 1997, 1998 Master-Bank          }
{                                                       }
{*******************************************************}

{ Note:
  - in Delphi 4.0 you must add DCLSTD40 and DCLSMP40 to the requires
    page of the package you install this components into.
  - in Delphi 3.0 you must add DCLSTD30 and DCLSMP30 to the requires
    page of the package you install this components into.
  - in C++Builder 3.0 you must add DCLSTD35 to the requires page of the
    package you install this components into. }

unit RxCtlReg;

{$I RX.INC}
{$D-,L-,S-}

interface

{ Register custom useful controls }

procedure Register;

implementation

{R *.D32}

uses
  Windows, Classes, RxRichEd;

procedure Register;
begin
  RegisterComponents('Win32', [TRxRichEdit]);
  RegisterNonActiveX([TRxRichEdit], axrComponentOnly);
end;

end.
