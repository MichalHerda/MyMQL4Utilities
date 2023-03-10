//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//***********************************************                                                              ************************************************
//***********************************************                                                              ************************************************
//***********************************************                                                              ************************************************
//***********************************************                                                              ************************************************
//***********************************************                        STOP MACHINE                          ************************************************
//***********************************************                                                              ************************************************
//***********************************************                                                              ************************************************
//***********************************************                                                              ************************************************
//***********************************************                                                              ************************************************
//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//*************************************************************************************************************************************************************
//+------------------------------------------------------------------+
//|                                                  StopMachine.mq4 |
//|                                                     Michal Herda |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
#property description "Close All Orders Immediately:\nIf Account Balance Is Less/Greater Than Allowed,\nIT USES ACCOUNT BALANCE, NOT EQUITY."
#property description "Initial Balance Is Calculated Once A Day If Writting Hour/Minute Comes.\nIt Is Also Reset Each Restart Program\nProgram Was Developed For VPS Running Purposes, To Prevent From Attempts Of Trading After Daily DD Limit Is Reached"
#property description "I Made Decision To Share This For Free. It Is Not Developed For Commercial Purposes.\nIf You Are Not Satisfied With The Options It Offers, Please Stop Using. "
///////////////////////////////////////////////////////////////////////////////////
#include <Controls\Dialog.mqh>
#include <Controls\Label.mqh>
#include <Controls\Edit.mqh>
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////          GUI CLASS             ////////////////////
/////////////////           DEFINES              ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//indent and gaps
#define INDENT_TOP                                     (8)
#define INDENT_LEFT                                    (15)
//for Button
#define LABEL_HEIGHT                                   (15)
#define LABEL_WIDTH                                    (40)
//for Edit
#define EDIT_HEIGHT                                    (20)
#define EDIT_WIDTH                                     (60)
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////          GUI CLASSES           ////////////////////
/////////////////          DEFINITION            ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//**************************************************************************************************************************************************************
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////        CMainMenu CLASS         ////////////////////
/////////////////           DEFINITION           ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
class CMainMenu : public CAppDialog
  {
public:
      CLabel                       m_label1 ;
      CLabel                       m_label2 ;
      CLabel                       m_label3 ;
      CLabel                       m_label4 ;
      CEdit                        m_edit1  ;
      CEdit                        m_edit2  ;
      CEdit                        m_edit3  ;
      CEdit                        m_edit4  ;
      CEdit                        m_edit5  ;
      CEdit                        m_edit6  ;
      CEdit                        m_edit7  ;
      CEdit                        m_edit8  ;
      CEdit                        m_edit9  ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                   CMainMenu (void) ;
                                  ~CMainMenu (void) ;
//--- create
      virtual bool                 Create (const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2) ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- chart event handler
      virtual bool                 OnEvent (const int id,const long &lparam,const double &dparam,const string &sparam) ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create dependent controls  
      bool                         CreateLabel1         (void) ;
      bool                         CreateLabel2         (void) ;
      bool                         CreateLabel3         (void) ;     
      bool                         CreateLabel4         (void) ;        
      bool                         CreateEdit1          (void) ;
      bool                         CreateEdit2          (void) ;
      bool                         CreateEdit3          (void) ;     
      bool                         CreateEdit4          (void) ;
      bool                         CreateEdit5          (void) ;
      bool                         CreateEdit6          (void) ;     
      bool                         CreateEdit7          (void) ; 
      bool                         CreateEdit8          (void) ;     
      bool                         CreateEdit9          (void) ; 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
   };
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            EVENT                 //////////////////
/////////////////           HANDLING               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
EVENT_MAP_BEGIN (CMainMenu)
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
EVENT_MAP_END (CAppDialog)   
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////        CONSTRUCTOR               //////////////////
/////////////////        DESTRUCTOR                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| Constructor                                                      |
//+------------------------------------------------------------------+
CMainMenu:: CMainMenu (void)
  {
  }
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CMainMenu::~CMainMenu (void)
  {
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////                                  //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool CMainMenu::Create (const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2)
  {
   if (!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false) ;
//--- create dependent controls
   if (!CreateLabel1())
      return(false) ;
   if (!CreateLabel2())
      return(false) ;
   if (!CreateLabel3())
      return(false) ;
   if (!CreateLabel4())
      return(false) ;  
   if (!CreateEdit1())
      return(false) ;
   if (!CreateEdit2())
      return(false) ;
   if (!CreateEdit3())
      return(false) ;
   if (!CreateEdit4())
      return(false) ;
   if (!CreateEdit5())
      return(false) ;    
   if (!CreateEdit6())
      return(false) ;
   if (!CreateEdit7())
      return(false) ; 
   if (!CreateEdit8())
      return(false) ;
   if (!CreateEdit9())
      return(false) ;       
//--- succeed  
   return(true);  
    }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////       GLOBAL VARIABLES         ////////////////////
/////////////////                                ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////// 
int                   Check_Hour                     =  1    ;
int                   Check_Minute                   =  30   ;
double                Drawdown_Allowed               = -5    ;
double                TopDrawdown_Allowed            = -5    ;
double                Profit_Allowed                 =  20   ;
double                Maximum_Balance                =  0    ;
CMainMenu             MainWindow                             ;
double                Initial_Balance = AccountBalance ()    ;   
bool                  AllChartsApply                 = true  ; 
extern int            Decimal_Places                 = 2     ;
double                Close_Price_Buy                        ;
double                Close_Price_Sell                       ;     
double                Daily_Profit                           ;  
bool                  Check_Drawdown_From_Maximum    = false ;                
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////           ON_INIT              ////////////////////
/////////////////                                ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
 //--- create timer
   EventSetMillisecondTimer(250);  
//--- create application dialog
   if(!MainWindow.Create (0,"                    Stop Machine ",0,40,40,290,280) )
      return (INIT_FAILED) ;
//--- run application
   MainWindow.Run() ;
//--- enable object create events
   ChartSetInteger (ChartID(), CHART_EVENT_OBJECT_CREATE, true) ;
//--- enable object delete events
   ChartSetInteger (ChartID(), CHART_EVENT_OBJECT_DELETE, true) ;
//--- succeed
   return(INIT_SUCCEEDED) ;
//---
 }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////           ON_DEINIT            ////////////////////
/////////////////                                ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   Comment("") ;
//--- destroy dialog
   MainWindow.Destroy(reason) ;
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////           CHART_EVENT          ////////////////////
/////////////////                                ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//| ChartEvent function                                              |
//+------------------------------------------------------------------+
void OnChartEvent(const int id,
                  const long &lparam,
                  const double &dparam,
                  const string &sparam)
  {
//---
   MainWindow.ChartEvent(id,lparam,dparam,sparam) ;
/////////////////////////////////////////////////////////////////////////
/*  if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit1" )
        {
         string Value1 = ObjectGetString(0, "Edit1", OBJPROP_TEXT, 0) ;
         Check_Hour  = StringToInteger ( Hour () ) ;
        }
/////////////////////////////////////////////////////////////////////////
  if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit2" )
        {
         string Value2 = ObjectGetString(0, "Edit2", OBJPROP_TEXT, 0) ;
         Check_Minute = StringToInteger ( Minute() ) ;   
        }
/////////////////////////////////////////////////////////////////////////
  if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit6" )
        {
         string Value3 = ObjectGetString(0, "Edit3", OBJPROP_TEXT, 0) ;
         Drawdown_Allowed = StringToDouble ( Seconds() ) ;   
        }
*/
/////////////////////////////////////////////////////////////////////////
  if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit4" )
        {
         string Value4 = ObjectGetString(0, "Edit4", OBJPROP_TEXT, 0) ;
         Check_Hour  = StringToInteger(Value4) ;
        }
/////////////////////////////////////////////////////////////////////
   if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit5" )
        {
         string Value5 = ObjectGetString(0, "Edit5", OBJPROP_TEXT, 0) ;
         Check_Minute = StringToInteger (Value5) ;   
        }
/////////////////////////////////////////////////////////////////////
  if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit6" )
        {
         string Value6 = ObjectGetString(0, "Edit6", OBJPROP_TEXT, 0) ;
         Drawdown_Allowed = StringToDouble (Value6) ;   
        }
/////////////////////////////////////////////////////////////////////
   if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit7" )
        {
         string Value7 = ObjectGetString(0, "Edit7", OBJPROP_TEXT, 0) ;
         TopDrawdown_Allowed = StringToDouble (Value7) ;   
        }
/////////////////////////////////////////////////////////////////////
  if (id == CHARTEVENT_OBJECT_ENDEDIT && sparam == "Edit8" )
        {
         string Value8 = ObjectGetString(0, "Edit8", OBJPROP_TEXT, 0) ;
         Profit_Allowed = StringToDouble (Value8) ;   
        }
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 1                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit1(void)
  {
//--- coordinates
   int x1 = INDENT_LEFT  ;
   int y1 = ( 2 * INDENT_TOP ) + LABEL_HEIGHT  ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + EDIT_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit1.Create(m_chart_id,"Edit1",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_edit1.Text ( IntegerToString ( TimeHour ( TimeLocal () ) ) ) )
      return(false) ;
   if(!m_edit1.ReadOnly(true))
      return(false) ;
   if(!m_edit1.TextAlign(ALIGN_CENTER))
      return(true) ;  
   if(!ObjectSetString(0,"Edit1",OBJPROP_TOOLTIP,"Current Hour"))
      return (false) ; 
   if ( !Add (m_edit1) )
      return(false) ;   
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 2                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit2(void)
  {
//--- coordinates
   int x1 = ( 2 * INDENT_LEFT ) + EDIT_WIDTH ;
   int y1 = ( 2 * INDENT_TOP ) + LABEL_HEIGHT  ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + EDIT_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit2.Create(m_chart_id,"Edit2",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_edit2.Text ( IntegerToString ( TimeMinute ( TimeLocal() ) ) ) )
      return(false) ;
   if(!m_edit2.ReadOnly(true))
      return(false) ;
   if(!m_edit2.TextAlign(ALIGN_CENTER))
      return(true) ;  
   if(!ObjectSetString(0,"Edit2",OBJPROP_TOOLTIP,"Current Minute"))
      return (false) ; 
   if ( !Add (m_edit2) )
      return(false) ;   
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 3                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit3(void)
  {
//--- coordinates
   int x1 = ( 3 * INDENT_LEFT ) + ( 2 * EDIT_WIDTH )  ;
   int y1 = ( 2 * INDENT_TOP ) + LABEL_HEIGHT  ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + EDIT_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit3.Create(m_chart_id,"Edit3",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_edit3.Text(IntegerToString( TimeSeconds ( TimeLocal () ) ) ) )
      return(false) ;
   if(!m_edit3.ReadOnly(true))
      return(false) ;
   if(!m_edit3.TextAlign(ALIGN_CENTER))
      return(true) ;  
   if(!ObjectSetString(0,"Edit3",OBJPROP_TOOLTIP,"Current Second"))
      return (false) ; 
   if ( !Add (m_edit3) )
      return(false) ;   
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 4                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit4(void)
  {
//--- coordinates
   int x1 = ( 3.75 * INDENT_LEFT ) ;
   int y1 = ( 4 * INDENT_TOP ) + ( 2 * LABEL_HEIGHT ) + EDIT_HEIGHT ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + EDIT_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit4.Create(m_chart_id,"Edit4",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_edit4.Text(IntegerToString( Check_Hour ) ) )
      return(false) ;
   if(!m_edit4.ReadOnly(false))
      return(true) ;
   if(!m_edit4.TextAlign(ALIGN_CENTER))
      return(true) ;  
   if(!ObjectSetString(0,"Edit4",OBJPROP_TOOLTIP,"Hour Of Writting Initial Daily Balance"))
      return (false) ; 
   if ( !Add (m_edit4) )
      return(false) ;   
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 5                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit5(void)
  {
//--- coordinates
   int x1 = ( 4.75 * INDENT_LEFT ) + EDIT_WIDTH ;
   int y1 = ( 4 * INDENT_TOP ) + ( 2 * LABEL_HEIGHT ) + EDIT_HEIGHT ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + EDIT_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit5.Create(m_chart_id,"Edit5",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_edit5.Text(IntegerToString( Check_Minute ) ) )
      return(false) ;
   if(!m_edit5.ReadOnly(false))
      return(true) ;
   if(!m_edit5.TextAlign(ALIGN_CENTER))
      return(true) ;  
   if(!ObjectSetString(0,"Edit5",OBJPROP_TOOLTIP,"Minute Of Writting Initial Daily Balance"))
      return (false) ; 
   if ( !Add (m_edit5) )
      return(false) ;   
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 6                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit6(void)
  {
//--- coordinates
   int x1 = INDENT_LEFT  ;
   int y1 = ( 6 * INDENT_TOP ) + ( 3 * LABEL_HEIGHT ) + ( 2 * EDIT_HEIGHT ) ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + EDIT_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit6.Create(m_chart_id,"Edit6",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_edit6.Text ( DoubleToString ( Drawdown_Allowed, Decimal_Places ) + " %") ) 
      return(false) ;
   if(!m_edit6.ReadOnly(false))
      return(true) ;
   if(!m_edit6.TextAlign(ALIGN_CENTER))
      return(true) ;  
   if(!ObjectSetString(0,"Edit6",OBJPROP_TOOLTIP,"Maximal Daily Drawdown Allowed. Remember To Include Negative Numbers"))
      return (false) ; 
   if ( !Add (m_edit6) )
      return(false) ;   
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 7                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit7(void)
  {
//--- coordinates
   int x1 = ( 2 * INDENT_LEFT ) + EDIT_WIDTH ;
   int y1 = ( 6 * INDENT_TOP ) + ( 3 * LABEL_HEIGHT ) + ( 2 * EDIT_HEIGHT ) ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + EDIT_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit7.Create(m_chart_id,"Edit7",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_edit7.Text ( DoubleToString ( TopDrawdown_Allowed, Decimal_Places ) + " %" ) )
      return(false) ;
   if(!m_edit7.ReadOnly(false))
      return(true) ;
   if(!m_edit7.TextAlign(ALIGN_CENTER))
      return(true) ;  
   if(!ObjectSetString(0,"Edit7",OBJPROP_TOOLTIP,"Maximal Drawdown If Previous Daily Profit Was Greater \nThan Maximal Percentage Drawdown Allowed, Multiplied By -1"))
      return (false) ; 
   if ( !Add (m_edit7) )
      return(false) ; 
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 8                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit8(void)
  {
//--- coordinates
   int x1 = ( 3 * INDENT_LEFT ) + ( 2 * EDIT_WIDTH ) ;
   int y1 = ( 6 * INDENT_TOP ) + ( 3 * LABEL_HEIGHT ) + ( 2 * EDIT_HEIGHT ) ;
   int x2 = x1 + EDIT_WIDTH ;
   int y2 = y1 + EDIT_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit8.Create(m_chart_id,"Edit8",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_edit8.Text( DoubleToString( Profit_Allowed, Decimal_Places ) + " %" ) )
      return(false) ;
   if(!m_edit8.ReadOnly(false))
      return(true) ;
   if(!m_edit8.TextAlign(ALIGN_CENTER))
      return(true) ;  
   if(!ObjectSetString(0,"Edit8",OBJPROP_TOOLTIP,"Maximal Daily Profit. "))
      return (false) ; 
   if ( !Add (m_edit8) )
      return(false) ; 
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////            EDIT 9                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateEdit9(void)
  {
//--- coordinates
   int x1 = ( 3.75 * INDENT_LEFT ) ;
   int y1 = ( 8 * INDENT_TOP ) + ( 4 * LABEL_HEIGHT ) + ( 3 * EDIT_HEIGHT ) ;
   int x2 = x1 + ( 2 * EDIT_WIDTH ) + INDENT_LEFT ;
   int y2 = y1 + EDIT_HEIGHT ;  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create
   if(!m_edit9.Create(m_chart_id,"Edit9",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_edit9.Text( DoubleToString( Daily_Profit, Decimal_Places ) + " %" ) )
      return(false) ;
   if(!m_edit9.ReadOnly(true))
      return(false) ;
   if(!m_edit9.TextAlign(ALIGN_CENTER))
      return(true) ;  
   if(!ObjectSetString(0,"Edit9",OBJPROP_TOOLTIP,"Profit / Drawdown"))
      return (false) ; 
   if ( !Add (m_edit9) )
      return(false) ; 
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           LABEL 1                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateLabel1(void)
  {
  //--- coordinates
   int x1 = ( 5 * INDENT_LEFT ) ;
   int y1 = INDENT_TOP ;
   int x2 = x1 + LABEL_WIDTH ;
   int y2 = INDENT_TOP + LABEL_HEIGHT ;
//--- create
   if(!m_label1.Create(m_chart_id,"Label1",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_label1.Text("   Local Time :"))
      return(false) ;
   if(!ObjectSetString(0,"Label1",OBJPROP_TOOLTIP,"Current Time"))
      return(false) ;
   if(!Add(m_label1))
      return(false) ;
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           LABEL 2                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateLabel2(void)
  {
//--- coordinates
   int x1 = ( 5 * INDENT_LEFT ) ;
   int y1 = ( 3 * INDENT_TOP ) + LABEL_HEIGHT + EDIT_HEIGHT ;
   int x2 = x1 + LABEL_WIDTH ;
   int y2 = INDENT_TOP + LABEL_HEIGHT ;
//--- create
   if(!m_label2.Create(m_chart_id,"Label2",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_label2.Text("  Writting Hour :"))
      return(false) ;
   if(!ObjectSetString(0,"Label2",OBJPROP_TOOLTIP,"Hour Of Initial Balance Writting"))
      return(false) ;
   if(!Add(m_label2))
      return(false) ;
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           LABEL 3                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateLabel3(void)
  {
//--- coordinates
   int x1 = ( 3 * INDENT_LEFT ) ;
   int y1 = ( 5 * INDENT_TOP ) + ( 2 * LABEL_HEIGHT ) + ( 2 * EDIT_HEIGHT ) ;
   int x2 = x1 + LABEL_WIDTH ;
   int y2 = INDENT_TOP + LABEL_HEIGHT ;
//--- create
   if(!m_label3.Create(m_chart_id,"Label3",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_label3.Text("Drawdown / Profit Allowed :"))
      return(false) ;
   if(!ObjectSetString(0,"Label3",OBJPROP_TOOLTIP,"Set Maximal Drawdown/Profit Allowed"))
      return(false) ;
   if(!Add(m_label3))
      return(false) ;
//--- succeed
   return(true);
  }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           LABEL 4                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CMainMenu::CreateLabel4(void)
  {
//--- coordinates
   int x1 = ( 5 * INDENT_LEFT ) ;
   int y1 = ( 7 * INDENT_TOP ) + ( 3 * LABEL_HEIGHT ) + ( 3 * EDIT_HEIGHT ) ;
   int x2 = x1 + LABEL_WIDTH ;
   int y2 = INDENT_TOP + LABEL_HEIGHT ;
//--- create
   if(!m_label4.Create(m_chart_id,"Label4",m_subwin,x1,y1,x2,y2))
      return(false) ;
   if(!m_label4.Text(" Current Profit :"))
      return(false) ;
   if(!ObjectSetString(0,"Label4",OBJPROP_TOOLTIP,"Current Profit / Drawdown"))
      return(false) ;
   if(!Add(m_label4))
      return(false) ;
//--- succeed
   return(true);
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////             ON TICK              //////////////////
/////////////////                                  //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void OnTick()
  {
   if ( AccountBalance () != 0 ) 
   {  
         //----------------------------------------------------------------------------------------------------------------------------------------------
         //-------------------------------------------------------SET INITIAL BALANCE IN CHECK POINT-----------------------------------------------------
         //----------------------------------------------------------------------------------------------------------------------------------------------
            if ( ( TimeHour ( TimeLocal() ) == Check_Hour ) && ( TimeMinute ( TimeLocal() ) == Check_Minute ) ) 
                  { Initial_Balance = AccountBalance () ; Maximum_Balance = 0 ; Check_Drawdown_From_Maximum = false ; }
         //----------------------------------------------------------------------------------------------------------------------------------------------
         //------------------------------------------------------------CALCULATE DAILY PROFIT------------------------------------------------------------
         //----------------------------------------------------------------------------------------------------------------------------------------------
            Daily_Profit = NormalizeDouble (  (  (  ( AccountBalance() - Initial_Balance ) / Initial_Balance ) * 100 ), Decimal_Places ) ;
                  if ( AccountBalance() > Maximum_Balance )         
                           { Maximum_Balance = AccountBalance () ; }
         //----------------------------------------------------------------------------------------------------------------------------------------------
         //--------------------------------------------------------------------DISPLAY-------------------------------------------------------------------
         //----------------------------------------------------------------------------------------------------------------------------------------------                  
         //   ObjectSetString(0,"Edit9",OBJPROP_TEXT,  Daily_Profit + " %" ) ; 
            Print ( " Initial Balance = ", Initial_Balance ) ;
            Print ( " Maximum Balance = ", Maximum_Balance, " ( It Starts Calculating After Account Balance > Initial Balance ) " ) ;
            Print ( " Daily profit = ", Daily_Profit," %" ) ;
         ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
            Print (" Writting Hour   = ", Check_Hour   ) ;
            Print (" Writting Minute = ", Check_Minute ) ;
            Print (" Check Drawdown From Maximum = ", Check_Drawdown_From_Maximum ) ;
         //----------------------------------------------------------------------------------------------------------------------------------------------
         //-----------------------------------------------------CONDITIONS TO CLOSE ALL ORDERS-----------------------------------------------------------
         //----------------------------------------------------------------------------------------------------------------------------------------------
            if ( Daily_Profit <  Drawdown_Allowed              ) { CloseAll() ; Print ( "Close All. Daily Limit Reached " ) ; } 
            if ( Daily_Profit >  Profit_Allowed                ) { CloseAll() ; Print ( "Close All. Daily Limit Reached " ) ; } 
            if ( Daily_Profit >= ( Drawdown_Allowed * ( -1 ) ) ) { Check_Drawdown_From_Maximum = true ; } 
         //----------------------------------------------------------------------------------------------------------------------------------------------
            if ( Check_Drawdown_From_Maximum == true )
                  {
                     if ( Daily_Profit <              ( ( Drawdown_Allowed * ( - 1 ) ) + TopDrawdown_Allowed  )   )
                           {
                              CloseAll() ; 
                              Print ( "Close All. Daily Limit Reached " ) ;
                           }
         }   
//      if ( AccountBalance () == 0 )
//         { Print ("Program Is OFF MODE - Account Balance = 0 ") ; }   
    }    
         








                             
/*   if ( Maximum_Balance > ( AccountBalance () + (          ( ( Drawdown_Allowed * ( -1 ) ) / 100) * AccountBalance ()      )             ))
         { Check_Drawdown_From_Maximum = true ; }
   if ( Check_Drawdown_From_Maximum == true )
      { 
         if (  AccountBalance () < ( Maximum_Balance - ( (TopDrawdown_Allowed/100) * Maximum_Balance ) ) ) CloseAll() ;
      }
*/      
//   if ( AccountBalance () < ( Initial_Balance - ( ( Drawdown_Allowed/100 ) * Initial_Balance ) ) ) CloseAll () ;
//   if ( AccountBalance () > ( Initial_Balance + ( ( Profit_Allowed/100 )   * Initial_Balance ) ) ) CloseAll () ;
   }
//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////             ON TIMER             //////////////////
/////////////////                                  //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void OnTimer()
  {
    ChartRedraw();
  
//---
    if ( TimeHour ( TimeLocal ()  ) < 10 )
      ObjectSetString(0,"Edit1",OBJPROP_TEXT, "0" + TimeHour ( TimeLocal () )     ) ;
    else
      ObjectSetString(0,"Edit1",OBJPROP_TEXT, TimeHour ( TimeLocal () )     ) ;
      
    if ( TimeMinute ( TimeLocal () ) < 10 )
      ObjectSetString(0,"Edit2",OBJPROP_TEXT, "0" + TimeMinute ( TimeLocal () )   ) ;
    else
      ObjectSetString(0,"Edit2",OBJPROP_TEXT, TimeMinute( TimeLocal () )   ) ;
      
    if ( TimeSeconds (TimeLocal() ) < 10 )
      ObjectSetString(0,"Edit3",OBJPROP_TEXT, "0" + TimeSeconds ( TimeLocal() )  ) ;  
    else
      ObjectSetString(0,"Edit3",OBJPROP_TEXT, TimeSeconds ( TimeLocal() )   ) ; 
      
     if ( Check_Hour < 10 )
      ObjectSetString(0,"Edit4",OBJPROP_TEXT, "0" + Check_Hour   ) ;
    else
      ObjectSetString(0,"Edit4",OBJPROP_TEXT, Check_Hour  ) ;
      
    if ( Check_Minute < 10 )
      ObjectSetString(0,"Edit5",OBJPROP_TEXT, "0" + Check_Minute ) ;  
    else
      ObjectSetString(0,"Edit5",OBJPROP_TEXT,  Check_Minute  ) ; 
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--------------------------------------------------------------------------------------------------------------------------//
//--------------------------------------------------DISPLAY STRINGS---------------------------------------------------------//
//--------------------------------------------------------------------------------------------------------------------------//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////      
    ObjectSetString ( 0, "Edit6", OBJPROP_TEXT, ( DoubleToString ( Drawdown_Allowed,    Decimal_Places ) + " %") ) ;
    ObjectSetString ( 0, "Edit7", OBJPROP_TEXT, ( DoubleToString ( TopDrawdown_Allowed, Decimal_Places ) + " %") ) ; 
    ObjectSetString ( 0, "Edit8", OBJPROP_TEXT, ( DoubleToString ( Profit_Allowed,      Decimal_Places ) + " %") ) ;
    ObjectSetString ( 0, "Edit9", OBJPROP_TEXT, ( DoubleToString ( Daily_Profit,        Decimal_Places ) + " %") ) ;
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////          
  }











//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************                                                                               *****************************************************************
//***************************************************                  FUNCTIONS TAKEN FROM MY PREVIOUS PROGRAMS                    *****************************************************************
//***************************************************                   THEY SHOULD BE UPLOADED INTO LIBRARIES                      *****************************************************************
//***************************************************                             AND #INCLUDE AS MQH                               *****************************************************************
//***************************************************                                                                               *****************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
//***************************************************************************************************************************************************************************************************
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////        GET CLOSE PRICE           //////////////////
/////////////////              BUY                 //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double GetClosePriceBuy(int i)
   {
   //--- wybrać pozycję/zlecenie z indeksem "i"      
//    Print("Selected Position Ticket is, ", OrderTicket() );
//    Print( "OrderSymbol = ",OrderSymbol() );
//    Print( "Symbol() = ", Symbol() );     
      Close_Price_Buy = MarketInfo(OrderSymbol(), MODE_BID);
//////////////////////////////////////////////////////////////////////////     
//     Print( "Close Price for Buy Position, Ticket No ",OrderTicket()," is ",Close_Price_Buy," . Remember That Slippage Is Possible, And It Is Not This EA Responsibility. Slippage Could Be Both Positive And Negative.") ; 
//////////////////////////////////////////////////////////////////////////     
      return(Close_Price_Buy);
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////        GET CLOSE PRICE           //////////////////
/////////////////              SELL                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double GetClosePriceSell(int i)
   {
   //--- wybrać pozycję/zlecenie z indeksem "i"     
//    Print("Selected Position Ticket is, ", OrderTicket() );
//    Print( "OrderSymbol = ",OrderSymbol() );
//    Print( "Symbol() = ", Symbol() );
      Close_Price_Sell = MarketInfo(OrderSymbol(), MODE_ASK);      
//////////////////////////////////////////////////////////////////////////          
//    Print( "Close Price for Buy Position, Ticket No ",OrderTicket()," is ",Close_Price_Buy," . Remember That Slippage Is Possible, And It Is Not This EA Responsibility. Slippage Could Be Both Positive And Negative.") ; 
//////////////////////////////////////////////////////////////////////////     
      return(Close_Price_Sell);
   }
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////             CLOSE                //////////////////
/////////////////              ALL                 //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CloseAll()
  {
   for(int i = OrdersTotal()-1; i >= 0; i--)
     {  if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)   
           if( AllChartsApply == true )
             {
               //--- wybrać tylko otwartą pozycję na sprzedaż
               if(OrderType() == OP_SELL)                
                     {
                     GetClosePriceSell(i);
                     Close_Sell_Instruction(Close_Price_Sell);
                     }                     
               if(OrderType() == OP_BUY)                
                     {
                     GetClosePriceBuy(i);
                     Close_Buy_Instruction(Close_Price_Buy );
                     }                                                     
            }
            
          if ( ( AllChartsApply == false ) && ( OrderSymbol()!=Symbol() ) )
               
                 {
                 Print("Position No ",OrderTicket()," Does Not Belong To This Chart, So Won't Be Closed. If You Need To Close This Position, Change Option For All Charts Or Launch Program On ",OrderSymbol()," Chart. ");
                
                 }
                 
              if ( ( AllChartsApply == false ) && ( OrderSymbol()==Symbol() ) )
               
                 {
                  //--- wybrać tylko otwartą pozycję na sprzedaż
                  if(OrderType() == OP_SELL)
                    
                     {
                     GetClosePriceSell(i);
                     Close_Sell_Instruction(Close_Price_Sell);
                     }
         
                  if(OrderType() == OP_BUY)
                    
                     {
                     GetClosePriceBuy(i);
                     Close_Buy_Instruction(Close_Price_Buy);
                     }
                 }                                           
     }
  }
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////                                  //////////////////
                                                            /////////////////           CLOSE BUY              //////////////////
                                                            /////////////////          INSTRUCTION             //////////////////
                                                            /////////////////                                  //////////////////
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////////////////////////////////////////////////////////
void Close_Buy_Instruction(double Close_Price_Buy)
  {
   if ( IsTradeAllowed ( OrderSymbol(), TimeCurrent () ) == false ) { Print("Market Closed ",OrderSymbol()," Trading Is Not Allowed, Cannot Close Selected Position ",OrderTicket() , " Please Check Hours Of Trading And Try Later ") ; }
   if ( OrderType() == OP_BUY )
                 {
                  //--- odświeżyć notowania
                  RefreshRates();
                  //--- zamknąć wybraną pozycję
                  if(OrderClose(OrderTicket(), // funkcja OrderTicket() znajdzie unikalny numer (ticket) pozycji
                                OrderLots(),   // funkcja OrderLots() znajdzie ilość lotów tej pozycji
                                Close_Price_Buy,           // aktualna cena kupna
                                0)            // poślizg cenowy, w punktach
                     == false)
                     //--- wyświetlić informację jeśli nie uda się zamknąć pozycję
                     Print("Position ",OrderTicket()," Not Closed "
                           ". Error = ",GetLastError());
                            else Print("Position ",OrderTicket()," Closed");
                 }
  }
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////                                  //////////////////
                                                            /////////////////          CLOSE SELL              //////////////////
                                                            /////////////////          INSTRUCTION             //////////////////
                                                            /////////////////                                  //////////////////
                                                            /////////////////////////////////////////////////////////////////////
                                                            /////////////////////////////////////////////////////////////////////
void Close_Sell_Instruction(double Close_Price_Sell)
  {
   if ( IsTradeAllowed ( OrderSymbol(), TimeCurrent () ) == false ) { Print("Market Close ",OrderSymbol()," Trading Is Not Allowed, Cannot Close Selected Position ",OrderTicket(), " Please Check Hours Of Trading And Try Later ") ; }
   if ( OrderType() == OP_SELL)
                 {
                  //--- odświeżyć notowania
                  RefreshRates();
                  //--- zamknąć wybraną pozycję
                  if(OrderClose(OrderTicket(), // funkcja OrderTicket() znajdzie unikalny numer (ticket) pozycji
                                OrderLots(),   // funkcja OrderLots() znajdzie ilość lotów tej pozycji
                                Close_Price_Sell,           // aktualna cena kupna
                                0)            // poślizg cenowy, w punktach
                     == false)
                     //--- wyświetlić informację jeśli nie uda się zamknąć pozycję
                     Print("Position ",OrderTicket()," Not Closed "
                           ". Error = ",GetLastError());
                           else Print("Position ",OrderTicket()," Closed");
                 }  
    else 
      Print(" ");
  }