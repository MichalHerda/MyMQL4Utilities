/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////       CLOSE ALL ORDERS         ////////////////////
/////////////////          ASSISTANT             ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
//+------------------------------------------------------------------+
//|                                   Close All Orders Assistant.mq4 |
//|                                                     Michal Herda |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "author: MICHAL HERDA"
#property link      "http://www.mql5.com"
#property version   "1.0"
#property description "This Program Sends Orders To Close All, Profit, Loss, Buy, Sell Positions. \nDepending On Pressed Button. You Can Apply Buttons To The Current Or All Charts" 
#property description "\nProgram Sends Orders To Close Positions, Does Not Close Positions Itself. \nPlease Note, That The Shutdown Process May Take a Longer."
#property description "\nProfit And Loss Options Do Not Take Into Account Additional Costs, Such As SWAP And Commission For Opening Positions. Profit/Loss Are Calculated From Opening Proce Only."
#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\RadioGroup.mqh>
#include <Controls\Defines.mqh>
/////////////////////////////////////////////////////////////////////         
/////////////////////////////////////////////////////////////////////
/////////////////                               /////////////////////        
/////////////////         GUI CLASS             /////////////////////
/////////////////          DEFINES              /////////////////////         
/////////////////                               /////////////////////
/////////////////////////////////////////////////////////////////////         
/////////////////////////////////////////////////////////////////////
//--- indents and gaps
#define INDENT_LEFT                         (16)      // indent from left (with allowance for border width)
#define INDENT_TOP                          (17)      // indent from top (with allowance for border width)
//--- for buttons
#define BUTTON_WIDTH                        (150)     // size by X coordinate
#define BUTTON_HEIGHT                       (22)      // size by Y coordinate
//-----for radio group
#define CONTROLS_GAP_X                      (5)       // gap by X coordinate
#define CONTROLS_GAP_Y                      (5)       // gap by Y coordinate
//--- for buttons
#define BUTTON_WIDTH_R                      (150)     // size by X coordinate
#define BUTTON_HEIGHT_R                     (45)      // size by Y coordinate
//--- for the indication area
#define EDIT_HEIGHT                         (18)      // size by Y coordinate
//--- for group controls
#define GROUP_WIDTH                         (150)     // size by X coordinate
#define LIST_HEIGHT                         (179)     // size by Y coordinate
#define RADIO_HEIGHT                        (42)      // size by Y coordinate
#define CHECK_HEIGHT                        (93)      // size by Y coordinate
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                ////////////////////
/////////////////          GUI CLASS             ////////////////////
/////////////////          DEFINITION            ////////////////////
/////////////////                                ////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
class CAppWindowButtonsAndRadioGroup : public CAppDialog {
public:
   CButton           m_button1;                       // the button object
   CButton           m_button2;
   CButton           m_button3;
   CButton           m_button4;
   CButton           m_button5;                       // the button object    ^^^^^^^^^^
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
   CRadioGroup       m_radio_group;                   // the radio group object
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
public:
                     CAppWindowButtonsAndRadioGroup(void);
                    ~CAppWindowButtonsAndRadioGroup(void);
//--- create
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- chart event handler
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
public:
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//--- create dependent controls
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
   virtual bool              CreateRadioGroup(void);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
   virtual bool              CreateButton1(void);
   virtual bool              CreateButton2(void);
   virtual bool              CreateButton3(void);
   virtual bool              CreateButton4(void);
   virtual bool              CreateButton5(void);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
   virtual void              OnClickButton1(void);
   virtual void              OnClickButton2(void);
   virtual void              OnClickButton3(void);
   virtual void              OnClickButton4(void);
   virtual void              OnClickButton5(void);
//////////////////////////////////////////////////////////////////////////////////////////////////////////////
   virtual void              OnChangeRadioGroup(void);
};
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            EVENT                 //////////////////
/////////////////           HANDLING               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
EVENT_MAP_BEGIN(CAppWindowButtonsAndRadioGroup)
/////////////////////////////////////////////////////////////////////
ON_EVENT(ON_CLICK,m_button1,OnClickButton1)
ON_EVENT(ON_CLICK,m_button2,OnClickButton2)
ON_EVENT(ON_CLICK,m_button3,OnClickButton3)
ON_EVENT(ON_CLICK,m_button4,OnClickButton4)
ON_EVENT(ON_CLICK,m_button5,OnClickButton5)
/////////////////////////////////////////////////////////////////////
ON_EVENT(ON_CHANGE,m_radio_group,OnChangeRadioGroup)
/////////////////////////////////////////////////////////////////////
EVENT_MAP_END(CAppDialog)
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
CAppWindowButtonsAndRadioGroup::CAppWindowButtonsAndRadioGroup(void) {
}
//+------------------------------------------------------------------+
//| Destructor                                                       |
//+------------------------------------------------------------------+
CAppWindowButtonsAndRadioGroup::~CAppWindowButtonsAndRadioGroup(void){
}
//+------------------------------------------------------------------+
//| Create                                                           |
//+------------------------------------------------------------------+
bool CAppWindowButtonsAndRadioGroup::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2){
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return(false);
//--- create dependent controls
   if(!CreateButton1())
      return(false);
   if(!CreateButton2())
      return(false);
   if(!CreateButton3())
      return(false);
   if(!CreateButton4())
      return(false);
   if(!CreateButton5())
      return(false);
   if(!CreateRadioGroup())
      return(false);
//--- succeed
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////             GLOBAL               //////////////////
/////////////////            VARIABLES             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double Close_Price_Buy = 0 ;
double Close_Price_Sell = 0 ;
bool AllChartsApply = false;
CAppWindowButtonsAndRadioGroup ExtDialog ;
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////          INITIALIZATION          //////////////////
/////////////////             FUNCTION             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
int OnInit(){
//--- create application dialog
   if(!ExtDialog.Create(0,"         Close All Orders",0,40,40,230,360))
      return(INIT_FAILED);
//--- run application
   ExtDialog.Run();
//--- succeed
   return(INIT_SUCCEEDED);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////       DEINITIALIZATION           //////////////////
/////////////////           FUNCTION               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void OnDeinit(const int reason) {
//---
   Comment("");
//--- destroy dialog
   ExtDialog.Destroy(reason);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////         ONCHART EVENT            //////////////////
/////////////////           FUNCTION               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void OnChartEvent(const int id,              // event ID
                  const long& lparam,        // event parameter of the long type
                  const double& dparam,      // event parameter of the double type
                  const string& sparam) {    // event parameter of the string type
   ExtDialog.ChartEvent(id,lparam,dparam,sparam);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////          RADIO GROUP             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CAppWindowButtonsAndRadioGroup::CreateRadioGroup(void) {
//--- coordinates
   int x1= INDENT_LEFT;
   int y1= INDENT_TOP;
   int x2= x1 + GROUP_WIDTH;
   int y2= y1 + RADIO_HEIGHT;
//--- create
   if(!m_radio_group.Create(0,0,0,x1,y1,x2,y2))
      return(false);
   if(!Add(m_radio_group))
      return(false);
//----add items
   if(!m_radio_group.AddItem("    Current Chart",1<<2))
      return(false);
   if(!m_radio_group.AddItem("       All Charts ",2<<3))
      return(false);
//----set default value
   if(AllChartsApply == false )  m_radio_group.Value(1<<2);
//--- succeed
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           BUTTON 1               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CAppWindowButtonsAndRadioGroup::CreateButton1(void){
//--- coordinates
   int x1 = INDENT_LEFT;        
   int y1 = ( 2 * INDENT_TOP ) + RADIO_HEIGHT ;          
   int x2 = x1 + BUTTON_WIDTH_R ;   
   int y2=  y1 + BUTTON_HEIGHT_R;   // y2 = 11 + 20  = 32  pixels
//--- create
   if(!m_button1.Create(0,"CLOSE ALL",0,x1,y1,x2,y2))
      return(false);
   if(!m_button1.Text("CLOSE ALL"))
      return(false);
   if(!Add(m_button1))
      return(false);
   m_button1.Locking(true);
   m_button1.Pressed(false);
//--- succeed
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           BUTTON 2               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CAppWindowButtonsAndRadioGroup::CreateButton2(void){
//--- coordinates
   int x1 = INDENT_LEFT;   
   int y1 = ( 3 * INDENT_TOP) + RADIO_HEIGHT + BUTTON_HEIGHT_R ;                                    
   int x2 = x1 + BUTTON_WIDTH ;                                
   int y2 = y1  +BUTTON_HEIGHT ;                               
//--- create
   if(!m_button2.Create(0,"CLOSE PROFIT",0,x1,y1,x2,y2))
      return(false);
   if(!m_button2.Text("CLOSE PROFIT"))
      return(false);
   if(!Add(m_button2))
      return(false);
   m_button2.Locking(true);
   m_button2.Pressed(false);
//--- succeed
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           BUTTON 3               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CAppWindowButtonsAndRadioGroup::CreateButton3(void) {
//--- coordinates
   int x1 = INDENT_LEFT ;    
   int y1 = ( 4 * INDENT_TOP ) + RADIO_HEIGHT + BUTTON_HEIGHT_R + BUTTON_HEIGHT ;                                    
   int x2 = x1 + BUTTON_WIDTH ;                              
   int y2 = y1 + BUTTON_HEIGHT ;                             
//--- create
   if(!m_button3.Create(0,"CLOSE LOSS",0,x1,y1,x2,y2))
      return(false);
   if(!m_button3.Text("CLOSE LOSS"))
      return(false);
   if(!Add(m_button3))
      return(false);
   m_button3.Locking(true);
   m_button3.Pressed(false);
//--- succeed
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           BUTTON 4               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CAppWindowButtonsAndRadioGroup::CreateButton4(void){
//--- coordinates
   int x1 = INDENT_LEFT ;    
   int y1 = ( 5 * INDENT_TOP ) + RADIO_HEIGHT + BUTTON_HEIGHT_R + ( 2 * BUTTON_HEIGHT ) ;                              
   int x2 = x1 + BUTTON_WIDTH ;                                
   int y2 = y1 + BUTTON_HEIGHT ;                               
//--- create
   if(!m_button4.Create(0,"CLOSE BUY",0,x1,y1,x2,y2))
      return(false);
   if(!m_button4.Text("CLOSE BUY"))
      return(false);
   if(!Add(m_button4))
      return(false);
   m_button4.Locking(true);
   m_button4.Pressed(false);
//--- succeed
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CREATE                //////////////////
/////////////////           BUTTON 5               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
bool CAppWindowButtonsAndRadioGroup::CreateButton5(void){
//--- coordinates
   int x1 = INDENT_LEFT ;   
   int y1 = ( 6 * INDENT_TOP ) + RADIO_HEIGHT + BUTTON_HEIGHT_R + ( 3 * BUTTON_HEIGHT ) ;                                         
   int x2 = x1 + BUTTON_WIDTH ;                               
   int y2 = y1 + BUTTON_HEIGHT ;                             
//--- create
   if(!m_button5.Create(0,"CLOSE SELL",0,x1,y1,x2,y2))
      return(false);
   if(!m_button5.Text("CLOSE SELL"))
      return(false);
   if(!Add(m_button5))
      return(false);
   m_button5.Locking(true);
   m_button5.Pressed(false);
//--- succeed
   return(true);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////           ON_CHANGE              //////////////////
/////////////////          RADIO GROUP             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CAppWindowButtonsAndRadioGroup::OnChangeRadioGroup(void) {
   if(m_radio_group.Value() == 4)
     {
      AllChartsApply = false;
      Print( "Option Changed : Applied For ", Symbol() );
     }
   if(m_radio_group.Value() == 16)
     {
      AllChartsApply = true;
      Print( "Option Changed : Applied For All Symbols" );
     }  
    if ( (m_radio_group.Value() == 4) && (m_radio_group.Value() == 16) )
      {Print("Error: Both >Current Chart< And >All Charts< Are Market. Please Change TimeFrame or Restart EA If Changing TimeFrame Does Not Work");}
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ON_CLICK              //////////////////
/////////////////            BUTTON 1              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CAppWindowButtonsAndRadioGroup::OnClickButton1(void) {
      Print("Close All Button Has Been Pressed");
      if(AllChartsApply==true){Print("Button Has Been Applied To All Charts");}
         else Print("Button Has Been Applied To The Current Chart"); 
      CloseAll();   
      Sleep(500);
      CAppWindowButtonsAndRadioGroup::m_button1.Pressed(false);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ON_CLICK              //////////////////
/////////////////            BUTTON 2              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CAppWindowButtonsAndRadioGroup::OnClickButton2(void) {
      Print("Close All Profit Button Has Been Pressed");
      if(AllChartsApply==true)Print("Button Has Been Applied To All Charts");
         else Print("Button Applied To The Current Chart"); 
      CloseProfit();  
      Sleep(500);
      CAppWindowButtonsAndRadioGroup::m_button2.Pressed(false);
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ON_CLICK              //////////////////
/////////////////            BUTTON 3              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CAppWindowButtonsAndRadioGroup::OnClickButton3(void){
      Print("Close All Loss Button Has Been Pressed");
      if(AllChartsApply==true)Print("Button Has Been Applied To All Charts");
         else Print("Button Applied To The Current Chart"); 
      CloseLoss();  
      Sleep(500);
      CAppWindowButtonsAndRadioGroup::m_button3.Pressed(false);     
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            ON_CLICK              //////////////////
/////////////////            BUTTON 4              //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CAppWindowButtonsAndRadioGroup::OnClickButton4(void) {
      Print("Close All Buy Button Has Been Pressed");
      if(AllChartsApply==true)Print("Button Has Been Applied To All Charts");
         else Print("Button Applied To The Current Chart"); 
      CloseBuy();
      Sleep(500);
      CAppWindowButtonsAndRadioGroup::m_button4.Pressed(false);     
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////             ON_CLICK             //////////////////
/////////////////             BUTTON 5             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CAppWindowButtonsAndRadioGroup::OnClickButton5(void) {
      Print("Close All Sell Button Has Been Pressed");
      if(AllChartsApply==true)Print("Button Has Been Applied To All Charts");
         else Print("Button Applied To TheCurrent Chart"); 
      CloseSell();
      Sleep(500);
      CAppWindowButtonsAndRadioGroup::m_button5.Pressed(false);     
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////           CLOSE BUY              //////////////////
/////////////////          INSTRUCTION             //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void Close_Buy_Instruction(double Close_Price_Buy) {
   if ( IsTradeAllowed ( OrderSymbol(), TimeCurrent () ) == false ) { Print("Market Closed ",OrderSymbol()," Trading Is Not Allowed, Cannot Close Selected Position ",OrderTicket() , " Please Check Hours Of Trading And Try Later ") ; }
   if ( OrderType() == OP_BUY ) {
                  //--- refresh
                  RefreshRates();
                  //--- close selected
                  if(OrderClose(OrderTicket(),             // search ticket
                                OrderLots(),               //        lot size
                                Close_Price_Buy,           //        buy price
                                0)                         //        slippery
                     == false)
                  //--- display log
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
void Close_Sell_Instruction(double Close_Price_Sell) {
   if ( IsTradeAllowed ( OrderSymbol(), TimeCurrent () ) == false ) { Print("Market Close ",OrderSymbol()," Trading Is Not Allowed, Cannot Close Selected Position ",OrderTicket(), " Please Check Hours Of Trading And Try Later ") ; }
   if ( OrderType() == OP_SELL) {
                  //--- refresh
                  RefreshRates();
                  //--- close selected
                  if(OrderClose(OrderTicket(),                       // search ticket
                                OrderLots(),                         // lot size
                                Close_Price_Sell,                    // price sell
                                0)                                   // slippery
                     == false)
                     //--- display log
                     Print("Position ",OrderTicket()," Not Closed "
                           ". Error = ",GetLastError());
                           else Print("Position ",OrderTicket()," Closed");
   }  
    else 
      Print(" ");
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////        GET CLOSE PRICE           //////////////////
/////////////////              BUY                 //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
double GetClosePriceBuy(int i) {    
      Close_Price_Buy = MarketInfo(OrderSymbol(), MODE_BID);
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
double GetClosePriceSell(int i) {
      Close_Price_Sell = MarketInfo(OrderSymbol(), MODE_ASK);      
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
void CloseAll() {
   for(int i = OrdersTotal()-1; i >= 0; i--){  
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)   
           if( AllChartsApply == true ){               
               if(OrderType() == OP_SELL){
                     GetClosePriceSell(i);
                     Close_Sell_Instruction(Close_Price_Sell);
                     }                     
               if(OrderType() == OP_BUY){
                     GetClosePriceBuy(i);
                     Close_Buy_Instruction(Close_Price_Buy );
                     }                                                     
          }            
          if ( ( AllChartsApply == false ) && ( OrderSymbol()!=Symbol() ) ) {
                 Print("Position No ",OrderTicket()," Does Not Belong To This Chart, So Won't Be Closed. If You Need To Close This Position, Change Option For All Charts Or Launch Program On ",OrderSymbol()," Chart. ");
          }
                 
           if ( ( AllChartsApply == false ) && ( OrderSymbol()==Symbol() ) ) {               
               if(OrderType() == OP_SELL){
                  GetClosePriceSell(i);
                  Close_Sell_Instruction(Close_Price_Sell);
                  }
                        
               if(OrderType() == OP_BUY){
                  GetClosePriceBuy(i);
                  Close_Buy_Instruction(Close_Price_Buy);
                  }
              }                                           
     }
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////       ORDER CLOSE PROFIT         //////////////////
/////////////////           INSTRUCTION            //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void OrderCloseProfitInstruction(int i) { 
         GetClosePriceBuy(i); GetClosePriceSell(i);                  
                  if((OrderType() == OP_BUY) && (Close_Price_Buy > OrderOpenPrice()) ) {
                     GetClosePriceBuy(i);
                     Close_Buy_Instruction(Close_Price_Buy);
                  }
                 
                  if((OrderType() == OP_SELL) && (Close_Price_Sell < OrderOpenPrice()) ) {
                     GetClosePriceBuy(i);
                     Close_Sell_Instruction(Close_Price_Sell );
                  }
         
                  if((OrderType() == OP_BUY) && (Close_Price_Buy < OrderOpenPrice()))
                     Print("Position No ",OrderTicket()," Is Not Profitable. It Will Not Be Closed. Price Calculation Does Not Include SWAP And Commisions. Its Calculation Is Based On Open Price");
            
                  if((OrderType() == OP_SELL) && (Close_Price_Sell > OrderOpenPrice()))
                     Print("Position No ",OrderTicket()," Is Not Profitable. It Will Not Be Closed. Price Calculation Does Not Include SWAP And Commisions. Its Calculation Is Based On Open Price");
            
                  else
                     GetLastError();     
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////              CLOSE               //////////////////
/////////////////             PROFIT               //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CloseProfit() {

   for(int i = OrdersTotal()-1; i >= 0; i--) {      
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)        
           if( AllChartsApply == true ){ 
                  OrderCloseProfitInstruction(i);     
           }
 /////////////////////////////////////////////////////////////////////////////////           
           if ( ( AllChartsApply == false ) && ( OrderSymbol()!=Symbol() ) ) {
                 Print("Position No ",OrderTicket()," Does Not Belong To This Chart. It Is Not Taken Into Account. " ) ;
           }
           if ( ( AllChartsApply == false ) && ( OrderSymbol() == Symbol() ) ) {
                 OrderCloseProfitInstruction(i);              
           }
     }
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////         ORDER CLOSE LOSS         //////////////////
/////////////////           INSTRUCTION            //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void OrderCloseLossInstruction(int i) {
            GetClosePriceBuy(i); GetClosePriceSell(i);
                  if((OrderType() == OP_BUY) && (Close_Price_Buy < OrderOpenPrice()) ) {                    
                     Close_Buy_Instruction(Close_Price_Buy);
                    }        
                  if((OrderType() == OP_SELL) && (Close_Price_Sell > OrderOpenPrice()) ) {                    
                     Close_Sell_Instruction(Close_Price_Sell );
                    }
         
                  if((OrderType() == OP_BUY) && (Close_Price_Buy > OrderOpenPrice()))
                     Print("Position No ",OrderTicket()," Is Not Lossy. It Will Not Be Closed. Price Calculation Does Not Include SWAP And Commisions. Its Calculation Is Based On Open Price");
            
                  if((OrderType() == OP_SELL) && (Close_Price_Sell < OrderOpenPrice()))
                      Print("Position No ",OrderTicket()," Is Not Lossy. It Will Not Be Closed. Price Calculation Does Not Include SWAP And Commisions. Its Calculation Is Based On Open Price");
            
                  else
                     GetLastError();  
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////            CLOSE                 //////////////////
/////////////////             LOSS                 //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CloseLoss() {
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
           if( AllChartsApply == true ) { 
                     OrderCloseLossInstruction(i);     
           }
 /////////////////////////////////////////////////////////////////////////////////           
           if ( ( AllChartsApply == false ) && ( OrderSymbol()!=Symbol() ) ) {
                  Print("Position No ",OrderTicket()," Does Not Belong To This Chart. It Is Not Taken Into Account. ");
           }
           if ( ( AllChartsApply == false ) && ( OrderSymbol() == Symbol() ) ) {
                 OrderCloseLossInstruction(i);              
           }       
   }
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////             CLOSE                //////////////////
/////////////////              BUY                 //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CloseBuy() {
/////////////////////////////////////////////////////////////////////////////////////////////////////////////
   for(int i = OrdersTotal()-1; i >= 0; i--) {
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)
         if (AllChartsApply == false) {
               if((OrderType() == OP_BUY)  && (OrderSymbol() == Symbol() ) ) {
                           GetClosePriceBuy(i);
                           Close_Buy_Instruction(Close_Price_Buy );
               }
               if( (OrderType() == OP_BUY ) && (OrderSymbol() != Symbol() ) )
                  {Print("Position No ",OrderTicket()," Does Not Belong To This Chart. It Is Not Taken Into Account. ");}
               if( OrderType() == OP_SELL )
                  {Print("Position No ",OrderTicket()," Is Sell. You Have Pressed Close Buy Button. Position Is Not Taken Into Account. ");}
         }
         if (AllChartsApply == true) {
               if(OrderType() == OP_BUY) {
                           GetClosePriceBuy(i);
                           Close_Buy_Instruction(Close_Price_Buy );
               }               
               if( OrderType() == OP_SELL )
                  {Print("Position No ",OrderTicket()," Is SELL. You Have Pressed Close Buy. Position Is Not Taken Into Account. ");}
         }
   }
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////             CLOSE                //////////////////
/////////////////              SELL                //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void CloseSell() {
///////////////////////////////////////////////////////////////////////////////
   for(int i = OrdersTotal()-1; i >= 0; i--) {      
      if(OrderSelect(i, SELECT_BY_POS, MODE_TRADES) == true)         
         if (AllChartsApply == false) {
               if((OrderType() == OP_SELL)  && (OrderSymbol() == Symbol() ) ) {
                           GetClosePriceSell(i);
                           Close_Sell_Instruction(Close_Price_Sell );
               }
               if( (OrderType() == OP_SELL ) && (OrderSymbol() != Symbol() ) )
                  {Print("Position No ",OrderTicket()," Does Not Belong To This Chart. It Is Not Taken Into Account. ");}
               if( OrderType() == OP_BUY )
                  {Print("Position No ",OrderTicket()," Is Buy. You Have Pressed Close Sell Button. Position Is Not Taken Into Account. ");}
         }
         if (AllChartsApply == true) {
               if(OrderType() == OP_SELL){
                           GetClosePriceSell(i);
                           Close_Sell_Instruction(Close_Price_Sell );
               }               
               if( OrderType() == OP_BUY )
                  {Print("Position No ",OrderTicket()," Is Buy. You Have Pressed Close Sell Button. Position Is Not Taken Into Account. ");}
         }
   }
}
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
/////////////////                                  //////////////////
/////////////////          ON TICK                 //////////////////
/////////////////                                  //////////////////
/////////////////                                  //////////////////
/////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////
void OnTick(){
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  