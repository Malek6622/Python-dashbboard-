import dash
import dash_auth
import dash_daq
import dash_core_components as dcc
import dash_html_components as html
import datetime 
import dash_bootstrap_components as dbc
import plotly 
import plotly.graph_objs as go
import pandas as pd
import numpy as np
import time
import subprocess as sp
from dash.dependencies import Input, Output, State
from functools import reduce
from plotly.subplots import make_subplots
from time import gmtime, strftime
import flask
import os

VALID_USERNAME_PASSWORD_PAIRS = {
    'fuba': 'fuba'
}

external_stylesheets = [ 'https://codepen.io/chriddyp/pen/bWLwgP.css', 'https://codepen.io/chriddyp/pen/brPBPO.css' ,[dbc.themes.BOOTSTRAP]]

app = dash.Dash('Fuba', external_stylesheets=external_stylesheets)
app.config.suppress_callback_exceptions = True
app.title = 'Fuba Printed Circuits '
css_directory = os.getcwd()
stylesheets = ['style.css']
static_css_route = '/C:/Users/1692/Desktop/FUBA Prinited Circuits/'

auth = dash_auth.BasicAuth(
    app,
    VALID_USERNAME_PASSWORD_PAIRS
)

def genrate_more():
  start = '1/1/2010'
  end = '31/12/2019'
  date_rng = pd.date_range(start=start, end= end , freq='H')
  df_f1 = pd.DataFrame(date_rng, columns=['date'])
  df_f1['Code_Mach'] = 'FUSION1'
  df_f1['data'] = np.random.randint(50,100,size=(len(date_rng)))
  df_f2 = pd.DataFrame(date_rng, columns=['date'])
  df_f2['Code_Mach'] = 'FUSION2'
  df_f2['data'] = np.random.randint(50,100,size=(len(date_rng)))
  df_f3 = pd.DataFrame(date_rng, columns=['date'])
  df_f3['Code_Mach'] = 'FUSION3'
  df_f3['data'] = np.random.randint(50,100,size=(len(date_rng)))
  df_f4 = pd.DataFrame(date_rng, columns=['date'])
  df_f4['Code_Mach'] = 'FUSION4'
  df_f4['data'] = np.random.randint(50,100,size=(len(date_rng)))
  df_d1 = pd.DataFrame(date_rng, columns=['date'])
  df_d1['Code_Mach'] = 'DISCOVERY1'
  df_d1['data'] = np.random.randint(50,100,size=(len(date_rng)))
  df_d2 = pd.DataFrame(date_rng, columns=['date'])
  df_d2['Code_Mach'] = 'DISCOVERY2'
  df_d2['data'] = np.random.randint(50,100,size=(len(date_rng)))
  df_d3 = pd.DataFrame(date_rng, columns=['date'])
  df_d3['Code_Mach'] = 'DISCOVERY3'
  df_d3['data'] = np.random.randint(50,95,size=(len(date_rng)))
  data_frames = [df_d1, df_d2, df_d3,df_f1, df_f2, df_f3, df_f4]
  df_merged = reduce(lambda  left,right: pd.merge(left,right,on=['date']), data_frames)
  df_merged.columns = ['date','DISCOVERY1','Discovery1','DISCOVERY2','Discovery2','DISCOVERY3','Discovery3','FUSION1', 'Fusion1','FUSION2', 'Fusion2', 'FUSION3', 'Fusion3','FUSION4', 'Fusion4']
  df_merged = df_merged.drop(["DISCOVERY1",'DISCOVERY2','DISCOVERY3','FUSION1','FUSION2','FUSION3','FUSION4'], axis=1)
  df_merged['AVG']= df_merged.mean(numeric_only=True,axis=0)
  df_merged['AVG'] = df_merged.iloc[:,1].rolling(window=24).mean()
  df_merged['AVG'].fillna(method = 'bfill', inplace = True)
  df_merged['Weekday'] = df_merged[['date']].apply(lambda x: datetime.datetime.strftime(x['date'], '%A'), axis=1)
  indexNames = df_merged[df_merged['Weekday'] == 'Saturday' ].index
  indexNames = indexNames.append(df_merged[df_merged['Weekday'] == 'Sunday' ].index)
  df_merged.drop(indexNames , inplace=True)
  df_merged['year'] = pd.DatetimeIndex(df_merged['date']).year
#  df_merged = df_merged.drop(["Saturday","Sunday"], axis=0)
  return df_merged

start = '1/1/2020'
end = datetime.datetime.now().strftime("%m-%d-%Y-%H:%M:%S")
date_rng = pd.date_range(start=start, end= end , freq='H')
df_f1 = pd.DataFrame(date_rng, columns=['date'])
df_f1['Code_Mach'] = 'FUSION1'
df_f1['data'] = np.random.randint(50,100,size=(len(date_rng)))
df_f2 = pd.DataFrame(date_rng, columns=['date'])
df_f2['Code_Mach'] = 'FUSION2'
df_f2['data'] = np.random.randint(50,100,size=(len(date_rng)))
df_f3 = pd.DataFrame(date_rng, columns=['date'])
df_f3['Code_Mach'] = 'FUSION3'
df_f3['data'] = np.random.randint(50,100,size=(len(date_rng)))
df_f4 = pd.DataFrame(date_rng, columns=['date'])
df_f4['Code_Mach'] = 'FUSION4'
df_f4['data'] = np.random.randint(50,100,size=(len(date_rng)))
df_d1 = pd.DataFrame(date_rng, columns=['date'])
df_d1['Code_Mach'] = 'DISCOVERY1'
df_d1['data'] = np.random.randint(50,100,size=(len(date_rng)))
df_d2 = pd.DataFrame(date_rng, columns=['date'])
df_d2['Code_Mach'] = 'DISCOVERY2'
df_d2['data'] = np.random.randint(50,100,size=(len(date_rng)))
df_d3 = pd.DataFrame(date_rng, columns=['date'])
df_d3['Code_Mach'] = 'DISCOVERY3'
df_d3['data'] = np.random.randint(50,95,size=(len(date_rng)))
data_frames = [df_d1, df_d2, df_d3,df_f1, df_f2, df_f3, df_f4]
df_merged = reduce(lambda  left,right: pd.merge(left,right,on=['date']), data_frames)
df_merged.columns = ['date','DISCOVERY1','Discovery1','DISCOVERY2','Discovery2','DISCOVERY3','Discovery3','FUSION1', 'Fusion1','FUSION2', 'Fusion2', 'FUSION3', 'Fusion3','FUSION4', 'Fusion4']
df_merged = df_merged.drop(["DISCOVERY1",'DISCOVERY2','DISCOVERY3','FUSION1','FUSION2','FUSION3','FUSION4'], axis=1)
df_merged['AVG']= df_merged.mean(numeric_only=True,axis=0)
df_merged['AVG'] = df_merged.iloc[:,1].rolling(window=24).mean()
df_merged['AVG'].fillna(method = 'bfill', inplace = True)
df_merged['Weekday'] = df_merged[['date']].apply(lambda x: datetime.datetime.strftime(x['date'], '%A'), axis=1)
indexNames = df_merged[df_merged['Weekday'] == 'Saturday' ].index
indexNames = indexNames.append(df_merged[df_merged['Weekday'] == 'Sunday' ].index)
df_merged.drop(indexNames , inplace=True)

df_merged['month'] = pd.DatetimeIndex(df_merged['date']).month
df_month = df_merged[df_merged['month'] == datetime.datetime.now().month]
df_month['day'] = pd.DatetimeIndex(df_month['date']).day

def generate_data_month_fusion():
  df_month_fusion= df_month.drop(["Discovery3","Discovery2","Discovery1","AVG"], axis=1)
  df_month_discovery= df_month.drop([ 'Fusion1', 'Fusion2', 'Fusion3', 'Fusion4',"AVG"], axis=1)
  df_month_fusion['AVG']= df_month.mean(numeric_only=True,axis=1)
  df_month_discovery['AVG']= df_month.mean(numeric_only=True,axis=1)
  return df_month_fusion  , df_month_discovery

def generate_data_2days_fusion(today,yesterday):
  df_fusion , df_discovery = generate_data_month_fusion()
  df_today_fusion = df_fusion[df_fusion['day'] == today.day]
  df_today_fusion['hour'] = pd.DatetimeIndex(df_today_fusion['date']).hour
  df_yesterday_fusion = df_fusion[df_fusion['day'] == yesterday.day]
  df_yesterday_fusion['hour'] = pd.DatetimeIndex(df_yesterday_fusion['date']).hour
  return df_today_fusion  , df_yesterday_fusion

def generate_data_2days_discovery(today,yesterday):
  df_fusion , df_discovery = generate_data_month_fusion()
  df_today_discovery = df_discovery[df_discovery['day'] == today.day]
  df_today_discovery['hour'] = pd.DatetimeIndex(df_today_discovery['date']).hour
  df_yesterday_discovery = df_discovery[df_discovery['day'] == yesterday.day]
  df_yesterday_discovery['hour'] = pd.DatetimeIndex(df_yesterday_discovery['date']).hour
  return df_today_discovery, df_yesterday_discovery


df_obj  = {'hour': ['0','1','2','3','4','5','6','7','8','9','10','11','12','13','14','15','16','17','18','19','20','21','22','23'],'OBJ': [85,85,60,85,85,60,85,85,60,85,85,60,85,85,60,85,85,60,85,85,60,85,85,60]}
df_obj = pd.DataFrame(df_obj , columns = ['hour','OBJ'])  

  #df_today['hour'] = df_today['date'].dt.hour
  #df_yesterday['hour'] = df_yesterday['date'].dt.hour

weekday = df_month['Weekday'].iloc[-1]
df_week = df_month.drop_duplicates(subset='Weekday', keep='last')

def generate_data_week_sorted():
  df_fusion , df_discovery = generate_data_month_fusion()
  weekday = df_fusion['Weekday'].iloc[-1]
  df_week_fusion = df_fusion.drop_duplicates(subset='Weekday', keep='last')
  df_week_discovery = df_discovery.drop_duplicates(subset='Weekday', keep='last')
  return df_week_fusion, df_week_discovery

today = datetime.date.today()
df_today = df_month[df_month['day'] == today.day]
df_today['hour'] = pd.DatetimeIndex(df_today['date']).hour
yesterday = today - datetime.timedelta(days=1)
df_yesterday = df_month[df_month['day'] == yesterday.day]
df_yesterday['hour'] = pd.DatetimeIndex(df_yesterday['date']).hour

features = df_today.columns[1:8]
opts = [{'label' : i, 'value' : i} for i in features]

#def generate_comp-data():
date_rng = pd.date_range(start=datetime.datetime.now().strftime("%d-%m-%Y-%H:%M:%S"), end=datetime.datetime.now().strftime("%d-%m-%Y-%H:%M:%S"), freq='H')
df_f1 = pd.DataFrame(date_rng, columns=['date'])
df_f1['Code_Mach'] = 'FUSION1'
df_f1['data'] = np.random.randint(50,100,size=(len(date_rng)))

df_f2 = pd.DataFrame(date_rng, columns=['date'])
df_f2['Code_Mach'] = 'FUSION2'
df_f2['data'] = np.random.randint(50,100,size=(len(date_rng)))

df_f3 = pd.DataFrame(date_rng, columns=['date'])
df_f3['Code_Mach'] = 'FUSION3'
df_f3['data'] = np.random.randint(50,100,size=(len(date_rng)))

df_f4 = pd.DataFrame(date_rng, columns=['date'])
df_f4['Code_Mach'] = 'FUSION4'
df_f4['data'] = np.random.randint(50,100,size=(len(date_rng)))

df_d1 = pd.DataFrame(date_rng, columns=['date'])
df_d1['Code_Mach'] = 'DISCOVERY1'
df_d1['data'] = np.random.randint(50,100,size=(len(date_rng)))

df_d2 = pd.DataFrame(date_rng, columns=['date'])
df_d2['Code_Mach'] = 'DISCOVERY2'
df_d2['data'] = np.random.randint(50,100,size=(len(date_rng)))

df_d3 = pd.DataFrame(date_rng, columns=['date'])
df_d3['Code_Mach'] = 'DISCOVERY3'
df_d3['data'] = np.random.randint(50,100,size=(len(date_rng)))

data_frames = [df_d1, df_d2, df_d3,df_f1, df_f2, df_f3, df_f4]

df_comp = reduce(lambda  left,right: pd.merge(left,right,on=['date']), data_frames)
df_comp.columns = ['date','DISCOVERY1','Discovery1','DISCOVERY2','Discovery2','DISCOVERY3','Discovery3','FUSION1', 'Fusion1','FUSION2', 'Fusion2', 'FUSION3', 'Fusion3','FUSION4', 'Fusion4']
df_comp = df_comp.drop(['date',"DISCOVERY1",'DISCOVERY2','DISCOVERY3','FUSION1','FUSION2','FUSION3','FUSION4'], axis=1)
#df_merged['Code_mach'] = ['Discovery1','Discovery2','Discovery3', 'Fusion1', 'Fusion2', 'Fusion3', 'Fusion4']
df_comp = df_comp.stack().rename_axis(('0','1')).reset_index()
df_comp = df_comp.drop(['0'], axis=1)
df_comp.columns = ['Code_Mach','AVG']
ips = ['10.4.212.211','10.4.212.112','10.4.212.213','10.4.212.214','10.4.212.9','10.4.212.201','10.4.212.202']
df_tab = pd.DataFrame(columns=['Code_Mach'])
df_tab['Code_Mach'] = ['Fusion1','Fusion2','Fusion3','Fusion4','Discovery1','Discovery2','Discovery3']
df_tab['IP@'] = ips
i= 0 
my_list =[]
for ip in ips:  
  status,result = sp.getstatusoutput("ping -c1 -w2 " + ip)
  if status == 0: 
      my_list.append("Workind")
  else:
      my_list.append("Stopped")
df_tab['State'] = my_list
df_tab['OS'] = ['CentOS','CentOS','CentOS','CentOS','Suse','Suse','Suse'] 
i= 0 
my_list =[]

for i in range(7):
  rand = df_merged['date'].iloc[-1]
  my_list.append(rand)
df_tab['Last Seen On'] = my_list

def generate_table(dataframe, max_rows=10):
      return html.Table([
        html.Thead(
            html.Tr([html.Th(col) for col in dataframe.columns],style={'color': '#0000A0'})
        ),
        html.Tbody([
            html.Tr([
                html.Td(dataframe.iloc[i][col]) for col in dataframe.columns
            ]) for i in range(min(len(dataframe), max_rows))
        ]#,style={'color':'rgb(255,165,0)'}
        )
    ])
#df['year'].unique()
dates = ['2010','2011','2012','2013','2014','2015','2016','2017','2018','2019','2020']
date_mark = {i : dates[i] for i in range(0, 11)}

def convert(list): 
  return tuple(list) 

def graph_comp():
  return  dcc.Graph(
           id='graph_comp',
           figure={
           'data': [
             go.Bar(
                    x = df_comp.AVG,
                    y = df_comp.Code_Mach,
                    #name =  'TRS today',
                    #type =  'barh'
                    orientation='h',
                    marker=dict(
                    color=['rgb(65,105,225)',
                           'rgb(255,165,0)',
                          'rgb(65,105,225)',
                          'rgb(255,165,0)' ,
                          'rgb(65,105,225)',
                          'rgb(255,165,0)',
                          'rgb(65,105,225)',
                           ]),
                    hovertemplate=None,
                     )],
            'layout': go.Layout(
             #hovermode="x unified",
             title = 'Each machines effectiveness compared to goal',
             xaxis = {'ticksuffix': '%'},
             yaxis = {'title' : ''},
             plot_bgcolor = "aliceblue",
 #'floralwhite' #'navajowhite' 
            )})

app.layout =  html.Div(children=[

      dbc.Row(
      html.Div(children= [
      dbc.Col(html.Div(
      html.H1(children='Fuba Printed Circuits', 
           style={ 'color': '#0000A0','display': 'inline-block', 'float':'left'}
             ))),
      dbc.Col(html.Div(
      html.H2(children='Equipements Report', 
           style={ 'color': ' #FFA500','display': 'inline-block','float':'left'}
             ))),
      dbc.Col(html.Div(
      html.A(html.Button('Refresh Page'),href='/', style={ 'display': 'inline-block', 'float':'right'}))),
      dbc.Col(html.Div(
      html.Div(children=[
      dcc.DatePickerRange(
         id='my-date-picker-range',
         start_date_placeholder_text="Start Period",
         end_date_placeholder_text="End Period",
         min_date_allowed='1-1-2020',
         max_date_allowed=datetime.datetime.now()),

          ],style={'display': 'inline-block','float':'Right','backgroundColor':'aliceblue' , 'marginRight':30})
       )),
         ] 
         ),style={'backgroundColor' : 'aliceblue'}),

      dbc.Row(dbc.Col(
      html.Div(children=[
      dcc.Dropdown(
          options=[
              {'label': "Overall Equipemnts Effectiveness", 'value': 'TRG'},
              {'label': "Each machines effectiveness compared to goal", 'value': 'comp'},
              {'label':  "Equipemnts Effectiveness Over The Last Five Days"  , 'value': 'week'},
              {'label': "Equipemnts Effectiveness Over This Month", 'value': 'month'},
              {'label': "Equipemnts Effectiveness Over The Last Year", 'value': 'year'},
          ],
          multi=True,
          value = ["TRG","comp","week","month","year"],
          clearable=False,

       )],style={'width': '100%'},className='row'))),

      html.Div(children=[
      html.Div(children=[
    html.Div(children =[  
    html.Label('Select one machine', style={ 'color': ' #0000A0'}),   
           dcc.Dropdown(id = 'opt', 
                options = opts,
                value = 'AVG'
                )
                ], style = {'width': '100%',
                            'fontSize' : '20px',
                            'display': 'inline-block',
                            'float':'left'}           
       ),

      html.Label('Last update date', style={ 'color': ' #0000A0'}),
      dbc.Input(id= 'input1', type='text', value=datetime.datetime.now().strftime("%d-%m-%Y")
        , style={'width':'100%','textAlign':'center'}
                ),
      html.Label('Last update time', style={ 'color': ' #0000A0'}),
      dbc.Input(id= 'input2', type='text', value=datetime.datetime.now().strftime("%H:%M:%S")
        , style={'width':'100%','textAlign':'center'}
                ),
      html.Label('Search:', style={ 'color': ' #0000A0'}),
      dbc.Input(id= 'search', type='text',value='',style={'width':'100%'}),

      html.Div(children=[
      dcc.Checklist(
           id = 'check',
           options=opts,
           #values=['M1', 'M2','M3','M4','M5','M6','M7'],
       )],style={'width':'100%'}),

             ],style={'width':'10%','marginLeft':0,'backgroundColor' :'#ffd485','height':'30%'}, className="two columns"
             ),

      html.Div(children=[dcc.Graph(id = 'plot-TRG'),
            #graph_TRG()
            ],style={'width':'60%','height':'100%' ,'marginLeft':0 , 'marginRight':0,'border':10}, className="five columns"
            ),
             
      html.Div(children=[
            graph_comp()
           ],style={'width': '27%', 'marginRight':0, 'marginLeft':0, 'float':'right' }
             ,className="five columns" 
            )],style={'width': '100%', 'marginRight':0, 'marginRight': 0 ,'max-width':50000},className='container'),
    

      html.Div(children=[
      html.Div(children=[
            dcc.Graph(id = 'plot-month')
          ],style={'width': '33%', 'marginRight':0, 'marginRight':0, 'float':'left','display': 'inline-block'},className="four columns" 
            ),

      html.Div(children=[
            #html.H4(children='AOI machines',style={'color': '#0000A0'}),
            generate_table(df_tab),
            
            ],style={ 'width': '30%', 'float':'left','display': 'inline-block'},className="four columns"
            ),


      html.Div(children=[
           dcc.Graph(id = 'plot-week')
           ],style={'width': '29%', 'marginRight':0, 'marginRight':0, 'float':'right','display': 'inline-block'},className="four columns"
             ),
            ],style={'width': '100%', 'marginRight':0, 'marginRight': 0 ,'max-width':50000},className='container'
            ),


      html.Div(children=[
        dcc.Graph(id = 'plot-year'),
        dcc.Loading(
            id="loading-1",
            type="default",
            children=html.Div(id="loading-output-1")
        ),
        ],style={'width': '100%', 'marginRight':0, 'marginRight': 0 ,'max-width':50000},className="twelve columns"),
      
      html.Div(children=[
        html.Label("Select Year"),
        dcc.RangeSlider(id = 'slider',
                        marks = date_mark,
                        min = 0,
                        max = 11,
                        value = [10])
                        ], style = {
                          'width' : '80%',
                          'fontSize' : '20px',
                          'padding-left' : '100px',
                          'display': 'inline-block',
                          'width': '100%'
                          ,'max-width':50000},className= 'container'),
      html.Div(children=[
        html.Label("Designed and coded by Malek Gafsi"),], style = {'fontSize' : '10px','float':"right"
          ,'padding-left' : 1000,'max-width':50000},className= 'row')
      ])

@app.callback(Output('plot-TRG', 'figure'),
             [Input('opt', 'value'),
              Input('check', 'value'),
              Input('search', 'value')
           ])
        
def update_fig_TRG(x1,x2,x3):
  fig = make_subplots(rows=1, cols=1)
  if x1 != None and x1 != 'AVG' :
    fig.append_trace(go.Bar(
      x = df_today.hour,
      #y = df_yesterday[input_value in df_yesterday.columns],
      y = df_yesterday[x1],
      name = 'TRS yesterday',
      marker=dict( color=['rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)' ])
      ), row=1, col=1),
    fig.append_trace(go.Bar(
      x = df_today.hour,
      #y = df_today[input_value in df_today.columns],
      y = df_today[x1],
      name = 'TRS today',

      marker=dict(color=['rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)' ])
      ), row=1, col=1),
    fig.append_trace(go.Scatter(x = df_today.hour,y = df_obj.OBJ,
      name = 'Objectif',
      mode="markers+lines",
      marker_size = 10,
      line = dict(width = 3),
      marker=dict(color=[ 'rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)'])
      ), row=1, col=1),


    fig.update_layout(
        barmode = 'group',
      hovermode="x",
      #showlegend=True,
      #hovermode="x unified",
      #clickData={'points': [], 'range': None},
      #config={'displayModeBar': True},
      title={
           'text':f'Overall Equipemnts Effectiveness: {x1}',
           'xanchor': 'center',
           'y':0.9,
               'x':0.5,
           'yanchor': 'top'},        
      xaxis = {'title' : 'hours'},
      yaxis = {'ticksuffix': '%'},
      plot_bgcolor = "aliceblue",
      #paper_bgcolor = "",
      autosize=False,
    
      ),
    return fig

  elif x2 != None and x2 != []:
    df_today_filtered = df_today[x2]
    df_yesterday_filtered = df_yesterday[x2]
    df_today_filtered['AVG'] = df_today_filtered.mean(numeric_only=True,axis=1)
    df_yesterday_filtered['AVG'] = df_yesterday_filtered.mean(numeric_only = True , axis = 1)

    fig.append_trace(go.Bar(
      x = df_today.hour,
      #y = df_yesterday[input_value in df_yesterday.columns],
      y = df_yesterday_filtered.AVG,
      name = 'TRS yesterday',
      marker=dict( color=['rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)' ])
      ), row=1, col=1),
    fig.append_trace(go.Bar(
      x = df_today.hour,
      #y = df_today[input_value in df_today.columns],
      y = df_yesterday_filtered.AVG,
      name = 'TRS today',
      marker=dict(color=['rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)' ])
      ), row=1, col=1),
    fig.append_trace(go.Scatter(x = df_today.hour,y = df_obj.OBJ,
      name = 'Objectif',
      mode = 'markers+lines',
      marker_size = 10,
      line = dict(width = 3),
      marker=dict(color=[ 'rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)'])
      ), row=1, col=1),


    fig.update_layout(
        barmode = 'group',
      hovermode="x",
      #showlegend=True,
      #hovermode="x unified",
      #clickData={'points': [], 'range': None},
      #config={'displayModeBar': True},
      title={
           'text': f'Overall Equipemnts Effectiveness: {x2}',
           'y':0.9,
               'x':0.5,
           'xanchor': 'center',
           'yanchor': 'top'}, 

      xaxis = {'title' : 'hours'},
      yaxis = {'ticksuffix': '%'},
      plot_bgcolor ="aliceblue",
      #paper_bgcolor = "",
      autosize=False,
    
      ),
    return fig
  elif  x3 in ['f','fu','fus','fusi','fusio','fusion','fs'] and (x1 == 'AVG' or x1==None):
    df_today_fusion  , df_yesterday_fusionn = generate_data_2days_fusion(today,yesterday)
    fig.append_trace(go.Bar(
        x = df_today.hour,
        #y = df_yesterday[input_value in df_yesterday.columns],
        y = df_yesterday_fusionn.AVG,
        name = 'TRS yesterday',
        marker=dict( color=['rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)' ])
        ), row=1, col=1),
    fig.append_trace(go.Bar(
        x = df_today.hour,
        #y = df_today[input_value in df_today.columns],
        y = df_today_fusion.AVG,
        name = 'TRS today',
        marker=dict(color=['rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)' ])
        ), row=1, col=1),
    fig.append_trace(go.Scatter(x = df_today.hour,y = df_obj.OBJ,
        name = 'Objectif',
        mode = 'markers+lines',
        marker_size = 10,
        line = dict(width = 3),
        marker=dict(color=[ 'rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)'])
        ), row=1, col=1),


    fig.update_layout(
        barmode = 'group',
      hovermode="x",
      #showlegend=True,
      #hovermode="x unified",
      #clickData={'points': [], 'range': None},
      #config={'displayModeBar': True},
      title={
           'text': f'Overall Equipemnts Effectiveness: {x3}',
           'y':0.9,
               'x':0.5,
           'xanchor': 'center',
           'yanchor': 'top'}, 

      xaxis = {'title' : 'hours'},
      yaxis = {'ticksuffix': '%'},
      plot_bgcolor ="aliceblue",
      #paper_bgcolor = "",
      autosize=False,
    
      ),
    return fig
  elif  x3 in ['d','di','dis','disc','disco','discov','discove','discover','discovery','dsc'] and (x1 == 'AVG' or x1==None):
    df_today_discovery,df_yesterday_discovery = generate_data_2days_discovery(today,yesterday)
    fig.append_trace(go.Bar(
      x = df_today.hour,
      #y = df_yesterday[input_value in df_yesterday.columns],
      y = df_yesterday_discovery.AVG,
      name = 'TRS yesterday',
      marker=dict( color=['rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)' ])
      ), row=1, col=1),
    fig.append_trace(go.Bar(
      x = df_today.hour,
      #y = df_today[input_value in df_today.columns],
      y = df_today_discovery.AVG,
      name = 'TRS today',
      marker=dict(color=['rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)' ])
      ), row=1, col=1),
    fig.append_trace(go.Scatter(x = df_today.hour,y = df_obj.OBJ,
      name = 'Objectif',
      mode = 'markers+lines',
      marker_size = 10,
      line = dict(width = 3),
      marker=dict(color=[ 'rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)'])
      ), row=1, col=1),


    fig.update_layout(
        barmode = 'group',
      hovermode="x",
      #showlegend=True,
      #hovermode="x unified",
      #clickData={'points': [], 'range': None},
      #config={'displayModeBar': True},
      title={
           'text': f'Overall Equipemnts Effectiveness: {x3}',
           'y':0.9,
               'x':0.5,
           'xanchor': 'center',
           'yanchor': 'top'}, 

      xaxis = {'title' : 'hours'},
      yaxis = {'ticksuffix': '%'},
      plot_bgcolor ="aliceblue",
      #paper_bgcolor = "",
      autosize=False,
    
      ),
    return fig
  else:
    fig.append_trace(go.Bar(
      x = df_today.hour,
      #y = df_yesterday[input_value in df_yesterday.columns],
      y = df_yesterday.AVG,
      name = 'TRS yesterday',
      marker=dict( color=['rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)','rgb(65,105,225)' ])
      ), row=1, col=1),
    fig.append_trace(go.Bar(
      x = df_today.hour,
      #y = df_today[input_value in df_today.columns],
      y = df_today.AVG,
      name = 'TRS today',

      marker=dict(color=['rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)','rgb(255,165,0)' ])
      ), row=1, col=1),
    fig.append_trace(go.Scatter(x = df_today.hour,y = df_obj.OBJ,
      name = 'Objectif',
      mode = 'markers+lines',
      marker_size = 10,
      line = dict(width = 3),
      marker=dict(color=[ 'rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)','rgb(34,139,34)'])
      ), row=1, col=1),


    fig.update_layout(
        barmode = 'group',
      hovermode="x",
      #showlegend=True,
      #hovermode="x unified",
      #clickData={'points': [], 'range': None},
      #config={'displayModeBar': True},
      title={
           'text': f'Overall Equipemnts Effectiveness',
           'xanchor': 'center',
           'y':0.9,
               'x':0.5,
           'yanchor': 'top'},
        #"""titlefont = {
        # 'family': 'Times New Roman',
          # 'size': 18,
          # 'color': '#000000' """
        #},
      xaxis = {'title' : 'hours'},
      yaxis = {'ticksuffix': '%'},
      plot_bgcolor = "aliceblue",
      #paper_bgcolor = "",
      autosize=False,
      ),
    return fig
@app.callback(Output('plot-month', 'figure'),
             [Input('opt', 'value'),
             Input('check', 'value'),
             Input('search', 'value')])
def update_fig_month(x1,x2,x3):
  fig = make_subplots(rows=1, cols=1)
 
  if x1 != None and x1 != 'AVG' :
    fig.append_trace(go.Scatter(
                x = df_month.date,
                y = df_month[x1],
               mode = 'markers+lines',
        marker_size = 3,
        line = dict(width = 2),
                 ), row=1, col=1)
    fig.update_layout(
             title={
           'text': f'Equipemnts Effectiveness Over This Month: {x1}',
           'y':0.9,
               'x':0.5,
           'xanchor': 'center',
           'yanchor': 'top'},
             #xaxis = {'title' : 'date'},
             yaxis = {#'title' : 'percentage'
                        'ticksuffix': '%'},
              #hovermode="x unified",
         hovermode="x",
             plot_bgcolor = "aliceblue" #  'floralwhite'#'lightyellow' ,
             #,paper_bgcolor = "aliceblue",
            )
    return fig 
  elif x2 != None and x2 != []:
    df_month_filtered = df_month[x2]
    df_month_filtered['AVG'] = df_month_filtered.mean(numeric_only=True,axis=1)
    fig.append_trace(go.Scatter(
               #x = df_month.date,
               x =df_month.date,
                y = df_month_filtered.AVG,
               mode = 'markers+lines',
        marker_size = 3,
        line = dict(width = 2),
                 ), row=1, col=1)
    fig.update_layout(

             title={
           'text': f'Equipemnts Effectiveness Over This Month: {x2}',
           'y':0.9,
               'x':0.5,
           'xanchor': 'center',
           'yanchor': 'top'},
              hovermode="x",
            plot_bgcolor = "aliceblue",
             yaxis = {#
                        'ticksuffix': '%'},
             xaxis=dict(
            type='date'
            ))
    return fig 

  elif  x3 in ['f','fu','fus','fusi','fusio','fusion','fs'] and (x1 == 'AVG' or x1==None):
    df_month_fusion, df_month_discovery = generate_data_month_fusion()
    fig.append_trace(go.Scatter(
               #x = df_month.date,
                x =df_month_fusion.date,
                y = df_month_fusion.AVG,
               mode = 'markers+lines',
        marker_size = 3,
        line = dict(width = 2),
                 ), row=1, col=1)
    fig.update_layout(

             title={
           'text': f'Equipemnts Effectiveness Over This Month: {x3}',
           'y':0.9,
               'x':0.5,
           'xanchor': 'center',
           'yanchor': 'top'},
              hovermode="x",
            plot_bgcolor = "aliceblue",
             yaxis = {#
                        'ticksuffix': '%'},
             xaxis=dict(
            type='date'
            ))
    return fig 

  elif  x3 in ['d','di','dis','disc','disco','discov','discove','discover','discovery','dsc'] and (x1 == 'AVG' or x1==None):
    df_month_fusion, df_month_discovery = generate_data_month_fusion()
    fig.append_trace(go.Scatter(
               #x = df_month.date,
                x =df_month_discovery.date,
                y = df_month_discovery.AVG,
               mode = 'markers+lines',
        marker_size = 3,
        line = dict(width = 2),
                 ), row=1, col=1)
    fig.update_layout(

             title={
           'text': f'Equipemnts Effectiveness Over This Month: {x3}',
           'y':0.9,
               'x':0.5,
           'xanchor': 'center',
           'yanchor': 'top'},
              hovermode="x",
            plot_bgcolor = "aliceblue",
             yaxis = {#
                        'ticksuffix': '%'},
             xaxis=dict(
            type='date'
            ))
    return fig 
  else :
    fig.append_trace(go.Scatter(
                x = df_month.date,
                y = df_month.AVG,
                mode='markers+lines',
                marker_size=10,
                line = dict(width = 1),
                 ), row=1, col=1)
    fig.update_layout(
        title={
           'text': 'Equipemnts Effectiveness Over This Month',
           'xanchor': 'center',
           'y':0.9, 
               'x':0.5,
           'yanchor': 'top'},

             #xaxis = {'title' : 'date'},
             yaxis = {#'title' : 'percentage'
                        'ticksuffix': '%'},
              #hovermode="x unified",
          hovermode="x",
              #paper_bgcolor = "aliceblue",
              plot_bgcolor = "aliceblue" #  'floralwhite'#'lightyellow' ,
            )
    return fig

@app.callback(Output('plot-week', 'figure'),
             [Input('opt', 'value'),
             Input('check', 'value'),
             Input('search','value')])
def update_fig_week(x1,x2,x3):
  if x1 != None and x1 != 'AVG' :
    fig = make_subplots(rows= 1, cols= 1)
    fig.append_trace(go.Scatter(
               x =  df_week[x1],
               y =df_week.Weekday ,
               orientation='h',
               mode = 'markers+lines',
          marker_size = 10,
          line = dict(width = 3)
               ),row = 1, col = 1)
    fig.update_layout(
               title={
             'text': f'Equipemnts Effectiveness Over The Last Five Days: {x1}',
             'y':0.9,
               'x':0.5,
             'xanchor': 'center',
             'yanchor': 'top'},              
               #hovermode="x unified",
               #xaxis = {'title' : 'date'},
             xaxis = {'ticksuffix': '%'},
               hovermode="x",
               plot_bgcolor = 'aliceblue',
               #paper_bgcolor = "aliceblue",
            )
  elif x2 != None and x2 != []:
    df_week_filtered = df_week[x2]
    df_week_filtered['AVG'] = df_week_filtered.mean(numeric_only=True,axis=1)
    fig = make_subplots(rows= 1, cols= 1)
    fig.append_trace(go.Scatter(
               x = df_week_filtered.AVG ,
               y = df_week.Weekday,
               orientation='h',
               mode = 'markers+lines',
          marker_size = 10,
          line = dict(width = 3)
               ),row = 1, col = 1)
    fig.update_layout(
               title={
             'text': f'Equipemnts Effectiveness Over The Last Five Days: {x2}',
             'y':0.9,
               'x':0.5,
             'xanchor': 'center',
             'yanchor': 'top'},              
               #hovermode="x unified",
               #xaxis = {'title' : 'date'},
               xaxis= {'ticksuffix': '%'},
               hovermode="x",
               plot_bgcolor = 'aliceblue',
               #paper_bgcolor = "aliceblue",
            )
  elif  x3 in ['f','fu','fus','fusi','fusio','fusion','fs'] and (x1 == 'AVG' or x1==None):
      df_week_fusion, df_week_discovery =   generate_data_week_sorted()
      fig = make_subplots(rows= 1, cols= 1)
      fig.append_trace(go.Scatter(
               x = df_week_fusion.AVG,
               y = df_week_fusion.Weekday,
               orientation='h',
              mode = 'markers+lines',
              marker_size = 10,
             line = dict(width = 3)
               #mode='markers',
               ),row = 1, col = 1)
      fig.update_layout(
               title={
             'text': f'Equipemnts Effectiveness Over The Last Five Days: {x3}',
             'xanchor': 'center',
             'y':0.9,
                 'x':0.5,
             'yanchor': 'top'},
          
                #hovermode="x unified",
               #xaxis = {'title' : 'date'},
              xaxis = {'ticksuffix': '%',
                   },
               plot_bgcolor = 'aliceblue',
               #marker_size=10,
               #paper_bgcolor = "aliceblue",
               hovermode="x",
            )
      return fig
  elif  x3 in ['d','di','dis','disc','disco','discov','discove','discover','discovery','dsc'] and (x1 == 'AVG' or x1==None):
      df_week_fusion, df_week_discovery =   generate_data_week_sorted()
      fig = make_subplots(rows= 1, cols= 1)
      fig.append_trace(go.Scatter(
               x = df_week_discovery.AVG,
               y = df_week_discovery.Weekday,
               orientation='h',
          mode = 'markers+lines',
          marker_size = 10,
          line = dict(width = 3)
               #mode='markers',
               ),row = 1, col = 1)
      fig.update_layout(
               title={
             'text': f'Equipemnts Effectiveness Over The Last Five Days: {x3}',
             'xanchor': 'center',
             'y':0.9,
                 'x':0.5,
             'yanchor': 'top'},
          
                #hovermode="x unified",
               #xaxis = {'title' : 'date'},
              xaxis = {'ticksuffix': '%',
                   },
               plot_bgcolor = 'aliceblue',
               #marker_size=10,
               #paper_bgcolor = "aliceblue",
               hovermode="x",
            )
      return fig
  else: 
    fig = make_subplots(rows= 1, cols= 1)
    fig.append_trace(go.Scatter(
               x = df_week.AVG,
               y = df_week.Weekday,
               orientation='h',
          mode = 'markers+lines',
          marker_size = 10,
          line = dict(width = 3)
               #mode='markers',
               ),row = 1, col = 1)
    fig.update_layout(
               title={
             'text': 'Equipemnts Effectiveness Over The Last Five Days',
             'xanchor': 'center',
             'y':0.9,
                 'x':0.5,
             'yanchor': 'top'},
          
                #hovermode="x unified",
               #xaxis = {'title' : 'date'},
              xaxis = {'ticksuffix': '%',
                   },
               plot_bgcolor = 'aliceblue',
               #marker_size=10,
               #paper_bgcolor = "aliceblue",
               hovermode="x",
            )
  return fig
@app.callback(Output('plot-year', 'figure'),
             [Input('opt', 'value'),
             Input('check', 'value'),
             Input('my-date-picker-range', 'start_date'),
             Input('my-date-picker-range', 'end_date'),
             Input('search','value'),
             Input('slider', 'value')
             ])
def update_fig_year(x1,x2,start_date,end_date,x3,x):
  fig = make_subplots(rows= 1, cols= 1)
  if x1 != None and x1 != 'AVG' :
    if start_date is not None and end_date is not None:
      df = df_merged[(df_merged.date >start_date )]
      df = df[(df.date < end_date )]  
      fig.append_trace(go.Scatter(
        x = df.date,
        y = df.AVG,
        mode = 'markers+lines',
        marker_size=3,
        line = dict(width = 3)
        ),row = 1, col = 1)
      fig.update_layout(
        #hovermode="x unified",
        title={
        'text': f'Equipemnts Effectiveness Over The Last Year: {x1}',
        'xanchor': 'center',
        'y':0.9,
        'x':0.5,
        'yanchor': 'top'},
        # xaxis = {'title' : 'date'},
        yaxis = {'ticksuffix': '%'},
        paper_bgcolor = "rgba(0,0,0,0)",
        plot_bgcolor = "aliceblue" # "snow" # 'seashell' ,
        ,hovermode="x",
        )
      return fig
    else:
      fig.append_trace(go.Scatter(
        x = df_merged.date,
        y = df_merged[x1],
        mode = 'markers+lines',
        marker_size = 3,
        line = dict(width = 2),
        ),row = 1, col = 1)
      fig.update_layout(
        #hovermode="x unified",
        title={
        'text': f'Equipemnts Effectiveness Over The Last Year: {x1}',
        'xanchor': 'center',
        'y':0.9,
        'x':0.5,
        'yanchor': 'top'},
        # xaxis = {'title' : 'date'},
        yaxis = {'ticksuffix': '%'},
        #paper_bgcolor = "aliceblue",
        plot_bgcolor = "aliceblue" # "snow" # 'seashell' ,
        ,hovermode="x",
        )
      return fig
  elif x2 != None and x2 != []:
    if start_date is not None and end_date is not None :
      df = df_merged[(df_merged.date >start_date )]
      df = df[(df.date < end_date )] 
      df_year_filtered = df_merged[x2]
      df_year_filtered['AVG'] = df_year_filtered.mean(numeric_only=True,axis=1)  
      fig.append_trace(go.Scatter(
        x = df.date,
        y = df_year_filtered.AVG,
        mode = 'markers+lines',
        marker_size=3,
        line = dict(width = 3)
        ),row = 1, col = 1)
      fig.update_layout(
        #hovermode="x unified",
        title={
        'text': f'Equipemnts Effectiveness Over The Last Year: {x2}',
        'xanchor': 'center',
        'y':0.9,
        'x':0.5,
        'yanchor': 'top'},
        # xaxis = {'title' : 'date'},
        yaxis = {'ticksuffix': '%'},
        paper_bgcolor = "rgba(0,0,0,0)",
        plot_bgcolor = "aliceblue" # "snow" # 'seashell' ,
        ,hovermode="x",
        )
      return fig
    else:
      df_year_filtered = df_merged[x2]
      df_year_filtered['AVG'] = df_year_filtered.mean(numeric_only=True,axis=1) 
      fig.append_trace(go.Scatter(
        x = df_merged.date,
        y = df_year_filtered.AVG,
        mode = 'markers+lines',
        marker_size = 3,
        line = dict(width = 2),
        #mode = 'markers'
        ),row = 1, col = 1)
      fig.update_layout(
        #hovermode="x unified",
        title={
        'text': f'Equipemnts Effectiveness Over The Last Year: {x2}',
        'xanchor': 'center',
        'y':0.9,
        'x':0.5,
        'yanchor': 'top'},
        # xaxis = {'title' : 'date'},
        yaxis = {'ticksuffix': '%'},
        #paper_bgcolor = "aliceblue",
        plot_bgcolor = "aliceblue" # "snow" # 'seashell' ,
        ,hovermode="x",
        )
      return fig
    
  elif start_date is not None and end_date and (x1 == 'AVG' or x1==None):
    df = df_merged[(df_merged.date >start_date )]
    df = df[(df.date < end_date )]  
    fig.append_trace(go.Scatter(
      x = df.date,
      y = df.AVG,
      mode = 'markers+lines',
      marker_size=3,
      line = dict(width = 3)
      ),row = 1, col = 1)
    fig.update_layout(
      #hovermode="x unified",
      title={
      'text': f'Equipemnts Effectiveness Over The Last Year: {x3}',
      'xanchor': 'center',
      'y':0.9,
      'x':0.5,
      'yanchor': 'top'},
      # xaxis = {'title' : 'date'},
      yaxis = {'ticksuffix': '%'},
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor = "aliceblue" # "snow" # 'seashell' ,
      ,hovermode="x",
      )
    time.sleep(1)
    return fig
  elif  x3 in ['f','fu','fus','fusi','fusio','fusion','fs'] and (x1 == 'AVG' or x1==None):
    df_merged_fusion= df_merged.drop(["Discovery3","Discovery2","Discovery1","AVG",'Weekday'], axis=1)
    df_merged_discovery= df_merged.drop([ 'Fusion1', 'Fusion2', 'Fusion3', 'Fusion4',"AVG",'Weekday'], axis=1)
    df_merged_fusion['AVG']= df_merged_fusion.mean(numeric_only=True,axis=1)
    df_merged_discovery['AVG']= df_merged_discovery.mean(numeric_only=True,axis=1)
    fig.append_trace(go.Scatter(
      x = df_merged.date,
      y = df_merged.AVG,
      mode = 'markers+lines',
      marker_size=3,
      line = dict(width = 3)
      ),row = 1, col = 1)
    fig.update_layout(
      #hovermode="x unified",
      title={
      'text': f'Equipemnts Effectiveness Over The Last Year: {x3}',
      'xanchor': 'center',
      'y':0.9,
      'x':0.5,
      'yanchor': 'top'},
      # xaxis = {'title' : 'date'},
      yaxis = {'ticksuffix': '%'},
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor = "aliceblue" # "snow" # 'seashell' ,
      ,hovermode="x",
      )
    time.sleep(1)
    return fig

  elif  x3 in ['d','di','dis','disc','disco','discov','discove','discover','discovery','dsc'] and (x1 == 'AVG' or x1==None):
    df_merged_fusion= df_merged.drop(["Discovery3","Discovery2","Discovery1","AVG",'Weekday'], axis=1)
    df_merged_discovery= df_merged.drop([ 'Fusion1', 'Fusion2', 'Fusion3', 'Fusion4',"AVG",'Weekday'], axis=1)
    df_merged_fusion['AVG']= df_merged_fusion.mean(numeric_only=True,axis=1)
    df_merged_discovery['AVG']= df_merged_discovery.mean(numeric_only=True,axis=1)
    fig.append_trace(go.Scatter(
      x = df_merged.date,
      y = df_merged.AVG,
      mode = 'markers+lines',
      marker_size=3,
      line = dict(width = 3)
      ),row = 1, col = 1)
    fig.update_layout(
      #hovermode="x unified",
      title={
      'text': f'Equipemnts Effectiveness Over The Last Year: {x3}',
      'xanchor': 'center',
      'y':0.9,
      'x':0.5,
      'yanchor': 'top'},
      # xaxis = {'title' : 'date'},
      yaxis = {'ticksuffix': '%'},
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor = "aliceblue" # "snow" # 'seashell' ,
      ,hovermode="x",
      )
    time.sleep(1)
    return fig
  elif x != [10] and x != None :
    df = genrate_more()
    df = df[df.year.astype(str) == dates[x[0]]] 
    fig.append_trace(go.Scatter(
        x = df.date,
        y = df.AVG,
        mode = 'markers+lines',
        marker_size = 10,
        line = dict(width = 1),
        ),row = 1, col = 1)
    fig.update_layout(
        #hovermode="x unified",
        title={
        'text': f'Equipemnts Effectiveness in: {dates[x[0]]}',
        'xanchor': 'center',
        'y':0.9,
        'x':0.5,
        'yanchor': 'top'},
        # xaxis = {'title' : 'date'},
        yaxis = {'ticksuffix': '%'},
        #paper_bgcolor = "aliceblue",
        plot_bgcolor = "aliceblue" # "snow" # 'seashell' ,
        ,hovermode="x",
        )
    time.sleep(1)
    return fig
  else :
    fig.append_trace(go.Scatter(
      x = df_merged.date,
      y = df_merged.AVG,
      mode = 'markers+lines',
      marker_size = 10,
      line = dict(width = 1),
      ),row = 1, col = 1)
    fig.update_layout(
      #hovermode="x unified",
      title={
      'text': 'Equipemnts Effectiveness Over The Last Year',
      'xanchor': 'center',
      'y':0.9,
      'x':0.5,
      'yanchor': 'top'},
      # xaxis = {'title' : 'date'},
      yaxis = {'ticksuffix': '%'},
      #paper_bgcolor = "aliceblue",
      plot_bgcolor = "aliceblue" # "snow" # 'seashell' ,
      ,hovermode="x",
      )
    time.sleep(1)
    return fig

@app.server.route('{}<stylesheet>'.format(static_css_route))
def serve_stylesheet(stylesheet):
    if stylesheet not in stylesheets:
        raise Exception(
            '"{}" is excluded from the allowed static files'.format(
                stylesheet
            )
        )
    return flask.send_from_directory(css_directory, stylesheet)

for stylesheet in stylesheets:
    app.css.append_css({"external_url": "/static/{}".format(stylesheet)})

for css in external_stylesheets:
    app.css.append_css({"external_url": css})

external_js = ['https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js'],
for js in external_stylesheets:
    app.scripts.append_script({'external_url': js})
  
if __name__ == '__main__':
    app.run_server(debug=True)

