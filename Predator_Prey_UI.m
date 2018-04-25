function Predator_Prey_UI
clear all
clear axes
close all

%--------------------------------------------------------------------------
%-------------------------Sets Default Figure Size-------------------------
%--------------------------------------------------------------------------
screensize = get( groot, 'Screensize' );
%brings figure away from edges
re_scale_figure = [(-screensize(3) * .1) (-screensize(4) * .1) ....
                   (screensize(3) * .2) (screensize(4) * .2)];
set(0,'defaultfigureposition',screensize-re_scale_figure)

%--------------------------------------------------------------------------
%------------------------Sets Default Color Pattern------------------------
%--------------------------------------------------------------------------
%Changes The Default Plotting Color Sets To A Custom Order For Better
%Visibility Of The Mixed Herd Simulations
color_pattern_1 = [    0    0.4470    0.7410;
                  0.6350    0.0780    0.1840;
                  0.4940    0.1840    0.5560;
                  0.9290    0.6940    0.1250;
                  0.4660    0.6740    0.1880;
                  0.3010    0.7450    0.9330;
                  0.8500    0.3250    0.0980;];
set(groot,'defaultAxesColorOrder',color_pattern_1)
%--------------------------------------------------------------------------
%----------------------------Sets UI Font Sizes----------------------------
%--------------------------------------------------------------------------
% Sets Font Sizes For The Text In The UI
large_font = 32; %32 24
medium_font = 16; %16 12
small_font = 12; %12 8
%-------------------------------------------------------------------------
%-------------------------------Basic Setup-------------------------------
%-------------------------------------------------------------------------
%All Funtions That Require Variables Changed in a Previous Funtion Are
%Nested Inside Eachother

name_of_save_file = [];
savefiletype_1 = '.txt';
savefiletype_2 = '.xlsx';

%Randomizes RNG Seed
rng('shuffle')
fh1=figure;

%Variable Used Later
runs = 1;
font_for_UI = 'Rockwell';
%---------------------------------------------------------
%---------------------------------------------------------
%--------------Persistant (Global) Variables--------------
%---------------------------------------------------------
%---------------------------------------------------------

%The Variables Listed Here Are Used Between Multiple Functions Or Runs, And
%Need To Retain Their Value. Each Variable Is Sorted Based on Which Aspect
%of The overall code it s used with. I.E. each variable is grouped with
%other variables that are used together, herdmemberinformation is group
%with other variables that effect the herd.

%----------------------------------------------------------
%----------------------Data Variables----------------------
%----------------------------------------------------------

%These variables are used to allow saving of information from data runs

%Save Data to .txt File? (1 = no ,2 = yes) (Default=1)
persistent savetotxtfile

%Save File Name
persistent filename

%Track if Save File Name Was Changed
persistent filename_entered

%Tracks original filepath
persistent currentpath

%Tracks chosen savepath
persistent savepath

%Tracks If A Run Has Been Started
persistent firstrun 
%-----------------------------------------------------------
%--------------------Simulation Settings--------------------
%-----------------------------------------------------------

%-------------------------------------------------------------------------
%The Variables found here effect the overall settings for each simulation.

%variables present

%--Type of Simelation
%-simulationtype

%--Run Time Settings
%-timesteps
%-predatorspawntimestep
%-predatortoherddistance
%-numberofruns
%-saverun
%-reuseherd
%-imputcounter

%--Animal Settings
%-minimalanimaldistance

%--Simulation Termination
%-stopsimulation
%-------------------------------------------------------------------------

%--Simulation Type (1 = DOD Reduction, 2 = Mixed Herd) (Default = 1)
%Determines Run Type
persistent simulationtype

%--Run Time Settings

%Determines Time of Simulation (Default = 100)
persistent timesteps

%Outputs Timesteps For Simulation
persistent timesteps_display

%Number of Runs (Simulations Run by Function) (Default = 10)
persistent numberofruns

%--Animal Settings

%Minimum Distance Between Animals (Default = 1)
persistent minimalanimaldistance


%-----------------------------------------------------------
%-----------------------LCH Variables-----------------------
%-----------------------------------------------------------

%-----------------------------------------------------------
%These variables are used within the LCH movement model and are constants
%used to determin how the prey should move

%Variables Present

%-fear_constant
%-weightofdistancetofear
%-----------------------------------------------------------

%How Fear Effects Heard (K in Viscido's Study) (Default = 0.375)
persistent fear_constant

%How much Fear Effects Individual Anmals at Distances (Default = 1)
persistent weightofdistancetofear

%-----------------------------------------------------------
%----------------------Herd Properties----------------------
%-----------------------------------------------------------

%-----------------------------------------------------------
%These variables determine how the herd moves and how many animals are
%present in the herd

%Variables Present

%-herdmovementrule2
%-herdmovementrule
%-voronimovementrule
%-herdmovementrule_2
%-noiseweight
%-numberofprey
%-usestandardherd
%-devisor
%-herdmemberinformation
%-----------------------------------------------------------
%Storage Variable For Herd Info
persistent herdmemberinformation

%Movement rule for second Herd (Default = LCH)
persistent herdmovementrule2

%Movement Rule for Rest of Herd (Defualt = LCH)
persistent herdmovementrule

%Percentage of Herd That Follows The First Movement Rule (Default = 50)
persistent herdmovementrule_1

%Percentage of Herd That Follows The Second Movement Rule (Default = 50)
persistent herdmovementrule_2

%Weight of Noise on Herd Movement (Default = 1)
persistent noiseweight

%Number of Animals in the Herd (Default = 100)
persistent numberofprey

%Allows Useage Of A Standard Herd From UI
persistent usestandardherd

%-----------------------------------------------------------
%---------------------Predator Settings---------------------
%-----------------------------------------------------------

%-----------------------------------------------------------
%These variables determine when/how the predator spawns, how many predators
%are spawned and what the minimum distance required for a kil is

%Variables Present

%--Predtor Basics
%-predatorinfo
%-killstoendhunt
%-predatorkilldistance

%--Predator Spawn Information
%-numberofpredators
%-predatorspawndistance

%-spawntype
%-lowestpossibley
%-----------------------------------------------------------

%--Predtor Basics
%Stores Predator information
persistent predatorinfo

%Number of Kills Before Predator Ends Hunt (Default = 1)
persistent killstoendhunt

%How Close Predator Must Be to Catch Prey (Default = 1)
persistent predatorkilldistance

%--Predator Spawn Information

%Number of Predators (Default = 1)
persistent numberofpredators

%Global Number of Predators (Always = numberofpredators at start of run)
persistent totalnumberofpredators

%Distance Predators spawn from herd (min 200, max 300, default 250)
persistent predatorspawndistance

%Keeps track of if predator has spawned or not (0 = no, 1 = yes)
persistent predator_spawned

%Keeps track of total kills in a run
persistent totalkills
%-----------------------------------------------------------
%--------------------------Voronoi--------------------------
%-----------------------------------------------------------

%-----------------------------------------------------------
%Variables used For Finding Voronoi Area And In The Voronoi Movement Model
%-----------------------------------------------------------

persistent v

persistent c

persistent mirrorpoints
%------------------------------------------------------------
%--------------------------Plotting--------------------------
%------------------------------------------------------------

%------------------------------------------------------------
%These Variables determine the manner in which data is ploted and the area 
%in which the prey spawns

%Variables Present

%--Plotting Variables
%-framerate
%-animation

%--Prey Spawn Variables
%-herdspawnarea_xaxis
%-herdspawnarea_yaxis
%-truncationdistance
%-----------------------------------------------------------

%--Plotting Variables

%Refresh Rate of Plot (Default = 1000)
persistent framerate

%Plot Storage Variable
persistent plot_info_storage

%Herd Spawn Area (Default 360 x 360 Grid)
persistent herdspawnarea_xaxis
persistent herdspawnarea_yaxis

%Plot Truncation Distance
persistent truncationdistance

%----------------------------------------------------------------
%-----------------------Tracking Variables-----------------------
%----------------------------------------------------------------

%----------------------------------------------------------------
%These variables are used to keep track of various things during the run
%from the number of dead animals to how many data runs have been done, the
%variables used to keep track of data from the final animal positions is
%also present

%Variables Present

%--Death Tracking
%-mutantdeaths
%-normaldeaths
%-total_mutantdeaths
%-total_normaldeaths

%--Run Variables
%-endofrun
%-type_of_data_collected

%--Data Collection
%-initial_voronoi_area
%-final_voronoi_area
%-percentofherdmemberswithdecreasing_dod
%-mean_percentofherdmemberswithdecreasing_dod
%-std_percentofherdmemberswithdecreasing_dod
%-sorted_percentofherdmemberswithdecreasing_dod
%-startofrun

%--Simulation Progress
%-stopsimulation
%-runinprogress
%-close_btn_pressed


%--Death Tracking
%Keeps Track of Mutant Deaths
persistent second_herd_deaths

%Keeps Track of Normal Herd Deaths
persistent first_herd_deaths

%Keeps Track of total Mutant Deaths
persistent total_deaths_rule_2

%Keeps Track of total Normal Herd Deaths
persistent total_deaths_rule_1

%--Run Variables

%Keeps Track Of If The Run Is Over Or Not
persistent endofrun

%Tracks What Type of Data Has Been Collected
%( 0 = None, 1 = DOD, 2 = Mixed Herd)
persistent type_of_data_collected

%Keeps Tack Of Initial And Final Voronoi Areas
persistent initial_voronoi_area
persistent final_voronoi_area

%Tracks Percent Change in DoD's Throughout Run
persistent percentofherdmemberswithdecreasing_dod

%Tracks Mean Percent Change in DoD's Throughout Run
persistent mean_percentofherdmemberswithdecreasing_dod

%Tracks STD Of Percent Change in DoD's Throughout Run
persistent std_percentofherdmemberswithdecreasing_dod

%Sorted Percent Change in DoD's Throughout Run for histogram
persistent sorted_percentofherdmemberswithdecreasing_dod

%--Simulation Progress
%Allows The Simulation To Be Stopped Mid Run
persistent stopsimulation

%Tracks If There Is A Simulation In Progress
persistent runinprogress

%Tracks If The Close Button Has Been Pressed Or Not
persistent close_btn_pressed
%----------------------------------------------------------------
%--------------------------UI Variables--------------------------
%----------------------------------------------------------------
%Variables Used In UI For Various Tasks

%Axes For Plotting Data On UI
persistent main_figure_plot_axes

%Stores Sting For Mixed Herd Output #1
persistent rule_1_string

%Stores Sting For Mixed Herd Output #1
persistent rule_2_string

%Allows Switching Of Ui Plots
persistent ui_plot_desired

%Allows Changing of UI Fontsizes
persistent change_font_size
%-------------------------------------------------------------------
%-------------------------------------------------------------------
%--------------Sets Global Variables to Default Values--------------
%-------------------------------------------------------------------
%-------------------------------------------------------------------

%----------------------------------------------------------------
%-------------------------Data Variables-------------------------
%----------------------------------------------------------------
%Allows Data Saving
    savetotxtfile = 1;

%Stores Save File Name
    filename = ' --- ';
    
%Tracks If Custom Savefile Name Was Entered
    filename_entered = 1;

%Tracks Defualt Save Path
    currentpath = pwd; 
    
%Tracks Save Path
    savepath = pwd;
    
%Tracks If At Least 1 Run has Been Started (0 = No, 1 = Yes)
    firstrun = 0;
%-----------------------------------------------------------------
%-----------------------Simulation Settings-----------------------
%-----------------------------------------------------------------

%--Simulation Type

    simulationtype = 1;

%--Run Ane Timestep Settings
    timesteps = 100;

    timesteps_display = 0;
    
    numberofruns = 10;

%--Animal Settings
    minimalanimaldistance = 1;

%--LCH Variables

    fear_constant = .375;

    weightofdistancetofear = 1;




%-----------------------------------------------------------
%----------------------Herd Properties----------------------
%-----------------------------------------------------------
%Default herd Movement Rule vector
    herdmemberinformation = [0 0];

%Default First Herd Movementr Rules
    herdmovementrule2 = 7;

    herdmovementrule = 1;

%Default Number of Animals Following Each Movement Rule
    herdmovementrule_1 = 100;

    herdmovementrule_2 = 50;

%Defualt Noise Weight
    noiseweight = 1;

%Default Number Of Prey
    numberofprey = 0;

%Standard Herd Implementation
    usestandardherd = 1;

%-----------------------------------------------------------
%---------------------Predator Settings---------------------
%-----------------------------------------------------------

%--Predtor Basics
    killstoendhunt = 1;
    
    predatorkilldistance = 1;

    predatorinfo = [-50 -50];

%--Predator Spawn Information
    numberofpredators = 1;

    totalnumberofpredators = 1;

    predatorspawndistance = 250;

    predator_spawned = 0;
    
    totalkills = 0;

%-----------------------------------------------------------
%--------------------------Voronoi--------------------------
%-----------------------------------------------------------
%Variables used For Finding Voronoi Area And In The Voronoi Movement Model
v = [];

c = [];

mirrorpoints = [];

%------------------------------------------------------------
%--------------------------Plotting--------------------------
%------------------------------------------------------------

%Framerate For pause Button Presses
    framerate = 1000;

%Storage Of Plot Info
    plot_info_storage = [];


%Herd Spawn Axis
    herdspawnarea_xaxis = 360;

    herdspawnarea_yaxis = 360;

%Extra Boundry Around The Spawn Area
    truncationdistance = 40;


%---------------------------------------------------------------
%-----------------------Variable Tracking-----------------------
%---------------------------------------------------------------

%--Keeps Track Of Animal Deaths
second_herd_deaths = 0;
first_herd_deaths = 0;

%--Keeps Track Of total Animal Deaths
total_deaths_rule_2 = 0;
total_deaths_rule_1 = 0;

%Tracks If At End Of Curretn Run Or Not
    endofrun = 1;

%Tracks What Type of Data Has Been Collected
    type_of_data_collected = 0;

%--Initializes Voronoi Area Tracking Variables
    initial_voronoi_area = 1;

    final_voronoi_area = 1;

%Tracks Percent Of Animals Whose DoD Decreased During A Run
    percentofherdmemberswithdecreasing_dod = [];

%Tracks Mean Percent Of Animals Whose DoD Decreased During A Run
    mean_percentofherdmemberswithdecreasing_dod = 0;

%Tracks STD Of Percent Of Animals Whose DoD Decreased During A Run
    std_percentofherdmemberswithdecreasing_dod = 0;
    
%Sorts Percent Of Animals Whose DoD Decreased During A Run
    sorted_percentofherdmemberswithdecreasing_dod = zeros(1,100);

%--Simulation Tracking
%Checks If Simulation Should Be Terminated Or Not (1 = No 2 = Yes)
    stopsimulation = 1;

%Checks If Simulation Is In Progress Or Not (1 = No 2 = Yes)
    runinprogress = 1;

%Checks If The Close Button Has been Pressed Or Not
    close_btn_pressed = 1;


%----------------------------------------------------------------
%--------------------------UI Variables--------------------------
%----------------------------------------------------------------
%Variables Used In UI For Various Tasks In UI

%Axes For Plotting Data On UI
   main_figure_plot_axes = 0;
   
%Sets Defualt Sting For Mixed Herd Output #1
    rule_1_string = 'LCH';
    
%Sets Defualt Sting For Mixed Herd Output #1
    rule_2_string = 'LCH W/ Noise';

%Sets Default Value To UI Plot Variable
    ui_plot_desired = 1;

%Sets Default Value Changing of UI Fontsizes Variable
    change_font_size = 1;

%----------------------------------------------------------
%----------------------------------------------------------
%--------------------Sets Up UI Control--------------------
%----------------------------------------------------------
%----------------------------------------------------------

%This Section Sets Up The User Interface That Allows The User To Control
%Various Simulation Settings Before Running A Simulation.

%---------------------------------------------------------
%-----------------------Outlines UI-----------------------
%---------------------------------------------------------

%-----------Title of Program-----------
btn1=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[1/5 15/16 3/5 1/16]...
    ,'fontname',font_for_UI...
    ,'string','Predator - Prey User Interface'...
    ,'fontsize',large_font....
    );
%-----------Closes Program-----------
btn2=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[7/8 15/16 1/8 1/16]...
    ,'fontname',font_for_UI...
    ,'string','Close'...
    ,'fontsize',large_font...
    ,'backgroundcolor','r'...
    ,'foregroundcolor','w'...
    ,'callback',{@end_code_now}...
    );

%--------------------------------------------------------
%----------------Controls Herd Properties----------------
%--------------------------------------------------------

%Title of Section
btn3=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[0 27/32 1/2 1/16]...
    ,'fontname',font_for_UI...
    ,'string','Herd Settings'...
    ,'fontsize',large_font...
    );

%-----------Controls Number Of Herd Members-----------

%Number of Herd Members
btn4=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[0 21/32 1/8 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'First Herd','# of Members'}...
    ,'fontsize',medium_font...
    );

%Controls Number of Members in The Herd
btn5=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[1/8 21/32 1/4 1/16]...
    ,'style','slider'...
    ,'sliderstep',[1/99 10/99]...
    ,'value',herdmovementrule_1...
    ,'min',1....
    ,'max',100....
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,1,0}...
    );

%Outputs Current Number of Herd Members Selected
btn6=uicontrol('parent',fh1...
    ,'style','edit'...
    ,'units','normal'...
    ,'position',[3/8 21/32 1/16 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','left'...
    ,'string',num2str(herdmovementrule_1)...
    ,'backgroundcolor',[.935 .935 .935]...
    ,'fontsize',large_font....
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,2,0}...
    );

%-----------Allows Usage Of Standard Herd-----------

%Controls Usage Of A Standard Herd versus A Randomly Generated One For
%Testing Code
btn22 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','text'...
    ,'position',[0 23/32 1/8 1/16]...
    ,'string',{'Initial Herd','Settings'}...
    ,'fontname',font_for_UI...
    ,'fontsize',medium_font...
    );
btn22a_ind1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[1/8 23/32 1/128 1/16]...
    ,'backgroundcolor','g'...
    );
btn22a_ind2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[31/128 23/32 1/128 1/16]...
    ,'backgroundcolor','g'...
    );
btn22b_ind1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[2/8 23/32 1/128 1/16]...
    ,'backgroundcolor','w'...
    );
btn22b_ind2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[47/128 23/32 1/128 1/16]...
    ,'backgroundcolor','w'...
    );
btn22a=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[17/128 23/32 7/64 1/16]...
    ,'style','pushbutton'...
    ,'string',{'Random Herd'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'callback',{@valueupdator,0,0,1,0,0,0,0,0,0,0}...
    );

btn22b=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[33/128 23/32 7/64 1/16]...
    ,'style','pushbutton'...
    ,'string',{'Reference Herd'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'callback',{@valueupdator,0,0,2,0,0,0,0,0,0,0}...
    );
%-----------Determins The Number of Second Herd Members-----------
%Number of Herd Members That Are Following The Second Movement Rule
btn38=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[0 19/32 1/8 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'Second Herd','# of Members'}...
    ,'fontsize',medium_font...
    );

%Controls Number of Herd Members Following The Second Movement Rule
%in The Herd
btn39=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[1/8 19/32 1/4 1/16]...
    ,'style','slider'...
    ,'sliderstep',[1/100 10/100]...
    ,'value',herdmovementrule_2...
    ,'min',0....
    ,'max',100....
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,1,0}...
    );

%Outputs Current Number of Herd Members Following The Second Movement Rule
btn40=uicontrol('parent',fh1...
    ,'style','edit'...
    ,'units','normal'...
    ,'position',[3/8 19/32 1/16 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','left'...
    ,'string',num2str(herdmovementrule_2)...
    ,'backgroundcolor',[.935 .935 .935]...
    ,'fontsize',large_font...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,2,0}...
    );


%--------------------------------------------------------
%-------------Controls Simulation Properties-------------
%--------------------------------------------------------


%Title of Section
btn7=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[1/16 9/32 6/16 1/16]...
    ,'fontname',font_for_UI...
    ,'string','Simulation Settings'...
    ,'fontsize',large_font...
    );

%-----------Controls Number Of Timesteps For The Run-----------

%Number of Timesteps
btn8=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[0 7/32 1/8 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'# of', 'Timesteps'}...
    ,'fontsize',medium_font...
    );

%Controls Number of Timesteps For The Run
btn9=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[1/8 7/32 1/4 1/16]...
    ,'style','slider'...
    ,'sliderstep',[10/4990 100/4990]...
    ,'value',timesteps...
    ,'min',10....
    ,'max',5000....
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,1,0}...
    );

%Outputs Current Number of timesteps Selected
btn10=uicontrol('parent',fh1...
    ,'style','edit'...
    ,'units','normal'...
    ,'position',[3/8 7/32 1/16 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','left'...
    ,'string',num2str(timesteps)...
    ,'backgroundcolor',[.935 .935 .935]...
    ,'fontsize',large_font...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,2,0}...
    );



%-----------Allows Number Of Runs To Be Changed In UI-----------

%Number of Runs
btn16=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[0 5/32 1/8 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'# of', 'Runs'}...
    ,'fontsize',medium_font...
    );

%Controls Number of Runs For Each Simulation
btn17=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[1/8 5/32 1/4 1/16]...
    ,'style','slider'...
    ,'sliderstep',[1/999 10/999]...
    ,'value',numberofruns...
    ,'min',1....
    ,'max',1000....
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,1,0}...
    );

%Outputs Current Number of Runs Selected
btn18=uicontrol('parent',fh1...
    ,'style','edit'...
    ,'units','normal'...
    ,'position',[3/8 5/32 1/16 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','left'...
    ,'string',num2str(numberofruns)...
    ,'backgroundcolor',[.935 .935 .935]...
    ,'fontsize',large_font...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,2,0}...
    );

%--------Noise Control-----------------------------
btn37=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[0 3/32 1/8 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'Noise', 'Weight'}...
    ,'fontsize',medium_font...
    );

%Controls Noise
btn34=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[1/8 3/32 1/4 1/16]...
    ,'style','slider'...
    ,'sliderstep',[25/500 1/5]...
    ,'value',noiseweight...
    ,'min',0....
    ,'max',5....
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,1,0}...
    );
%Outputs Current Noise
btn36=uicontrol('parent',fh1...
    ,'style','edit'...
    ,'units','normal'...
    ,'position',[3/8 3/32 1/16 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','left'...
    ,'backgroundcolor',[.935 .935 .935]...
    ,'string',num2str(noiseweight)...
    ,'fontsize',large_font...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,2,0}...
    );

%-------------------Simulation Type-------------------
%Labels Button
btn41=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[0 25/32 1/8 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'Simulation','Type'}...
    ,'fontsize',medium_font...
    );

%Allows Selection on Type Of Simulation Between DOD And Mixed Herd
btn42aback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[1/8 25/32 1/128 1/16]...
    ,'backgroundcolor','g'...
    );
btn42aback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[31/128 25/32 1/128 1/16]...
    ,'backgroundcolor','g'...
    );
btn42bback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[2/8 25/32 1/128 1/16]...
    ,'backgroundcolor','w'...
    );
btn42bback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[47/128 25/32 1/128 1/16]...
    ,'backgroundcolor','w'...
    );
btn42a=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[17/128 25/32 7/64 1/16]...
    ,'style','pushbutton'...
    ,'string',{'Domain of Danger'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'callback',{@valueupdator,0,1,0,0,0,0,0,0,0,0}...
    );
btn42b=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[33/128 25/32 7/64 1/16]...
    ,'style','pushbutton'...
    ,'string',{'Mixed Herd'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'callback',{@valueupdator,0,2,0,0,0,0,0,0,0,0}...
    );

%-------------------------------------------------------
%-----------Determins Movement Rules For Herd-----------
%-------------------------------------------------------
%Title of Section
btn19=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[1/16 65/128 6/16 1/16]...
    ,'fontname',font_for_UI...
    ,'string','Herd Movement Settings'...
    ,'fontsize',large_font...
    );

%---------Determins Movement Rule For Base Herd---------

%Title Of Section
btn304=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[0 57/128 1/8 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'1st Herd','Movement Rules'}...
    ,'fontsize',medium_font...
    );

%Controls Contorls Movement Rules For First Herd
%LCH
btn12aback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[1/8 61/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn12aback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[31/128 61/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn12a=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[17/128 61/128 7/64 1/32]...
    ,'style','pushbutton'...
    ,'string',{'LCH'}...
    ,'fontname',font_for_UI...   
    ,'fontsize',small_font...
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,1,0,0,0,0,0,0}...
    );
%LCH W/ Noise
btn12bback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[2/8 61/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn12bback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[47/128 61/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn12b=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[33/128 61/128 7/64 1/32]...
    ,'style','pushbutton'...
    ,'string',{'LCH + Noise'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,2,0,0,0,0,0,0}...
    );
%Voronoi
btn12cback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[1/8 57/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn12cback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[31/128 57/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn12c=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[17/128 57/128 7/64 1/32]...
    ,'style','pushbutton'...
    ,'string',{'Voronoi'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,3,0,0,0,0,0,0}...
    );
%Voronoi W/ Noise
btn12dback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[2/8 57/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn12dback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[47/128 57/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn12d=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[33/128 57/128 7/64 1/32]...
    ,'style','pushbutton'...
    ,'string',{'Voronoi + Noise'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,4,0,0,0,0,0,0}...
    );

%---------Determins Movement Rule For Second Herd---------

%Title Of Section
btn45=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[0 47/128 1/8 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'2nd Herd','Movement Rules'}...
    ,'fontsize',medium_font...
    );

%Controls Contorls Movement Rules For Second Herd
%LCH
btn46aback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[1/8 51/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn46aback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[31/128 51/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn46a=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[17/128 51/128 7/64 1/32]...
    ,'style','pushbutton'...
    ,'string',{'LCH'}...
    ,'fontname',font_for_UI...   
    ,'fontsize',small_font...
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,5,0,0,0,0,0}...
    );
%LCH W/ Noise
btn46bback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[2/8 51/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn46bback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[47/128 51/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn46b=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[33/128 51/128 7/64 1/32]...
    ,'style','pushbutton'...
    ,'string',{'LCH + Noise'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,6,0,0,0,0,0}...
    );
%Voronoi
btn46cback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[1/8 47/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn46cback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[31/128 47/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn46c=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[17/128 47/128 7/64 1/32]...
    ,'style','pushbutton'...
    ,'string',{'Voronoi'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,7,0,0,0,0,0}...
    );
%Voronoi W/ Noise
btn46dback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[2/8 47/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn46dback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[47/128 47/128 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn46d=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[33/128 47/128 7/64 1/32]...
    ,'style','pushbutton'...
    ,'string',{'Voronoi + Noise'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,8,0,0,0,0,0}...
    );
%Symbols Key For Mixed Herd Animation
btn67a=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[3/8 57/128 1/32 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'foregroundcolor',[0    0.4470    0.7410]...
    ,'string',{'x'}...
    ,'fontsize',large_font...
    ,'visible','off'...
    );
btn67b=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[3/8 47/128 1/32 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'foregroundcolor',[0.6350    0.0780    0.1840]...
    ,'string',{'+'}...
    ,'fontsize',large_font...
    ,'visible','off'...
    );
%--------------------------------------------------------------------
%-------------------------Data Output For UI-------------------------
%--------------------------------------------------------------------
%----Title Of Section
btn_title_output=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[1/2 27/32 1/2 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'DOD Run'}...
    ,'fontsize',large_font...
    );


%----Average Perecent Improvemetn In DOD
btn60=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[51/64 37/256 8/64 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'Avg % of Herd Improving DOD'}...
    ,'fontsize',medium_font...
    );

%Outputs Average Perecent Improvemetn In DOD
btn61=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[59/64 37/256 5/64 1/16]...
    ,'horizontalalignment','left'...
    ,'fontname',font_for_UI...
    ,'string',num2str(0)...
    ,'fontsize',large_font...
    );


%----Outputs Current Standard Deviation
%Lables Output (STD)
btn62a=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[51/64 21/256 8/64 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'Standard', 'Deviation'}...
    ,'fontsize',medium_font...
    );

%Outputs Current Value
btn62b=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[59/64 21/256 5/64 1/16]...
    ,'horizontalalignment','left'...
    ,'fontname',font_for_UI...
    ,'string',num2str(0)...
    ,'fontsize',large_font...
    );

%----Outputs Current Timestep
%Lables Output (timesteps)
btn63a=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[33/64 37/256 8/64 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'# of','Timesteps'}...
    ,'fontsize',medium_font...
    );

%Outputs Current Timestep
btn63b=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[41/64 37/256 10/64 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','left'...
    ,'string',num2str(0)...
    ,'fontsize',large_font...
    );

%----Outputs Current run
%Lables Output (run)
btn64a=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[33/64 21/256 8/64 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','center'...
    ,'string',{'# of',' Runs'}...
    ,'fontsize',medium_font...
    );

%Outputs Current run
btn64b=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[41/64 21/256 10/64 1/16]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','left'...
    ,'string',num2str(0)...
    ,'fontsize',large_font...
    );
%----Allows Swithcing Between Statistics And Current Animation
btn66aback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[34/64 52/64 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn66aback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[95/128 52/64 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn_66a=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[69/128 52/64 26/128 1/32]...
    ,'style','pushbutton'...
    ,'string',{'Statistics'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,0,0,1,1,0,0}...
    );
btn66bback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[48/64 52/64 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn66bback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[123/128 52/64 1/128 1/32]...
    ,'backgroundcolor','g'...
    );
btn_66b=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[97/128 52/64 26/128 1/32]...
    ,'style','pushbutton'...
    ,'string',{'Animation'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,0,0,2,1,0,0}...
    );


%Basic Output Plot
 main_figure_plot_axes = axes('parent',fh1,...
            'units','normal',...
            'position', [34/64 9/32 28/64 17/32]);   
bar(main_figure_plot_axes,1:100,...
    sorted_percentofherdmemberswithdecreasing_dod)
axis([0 100 0 100])

%-------------------------------------------------------------------
%----------------------------Data Saving----------------------------
%-------------------------------------------------------------------

%-----------Controls Data Saving-----------
btn23back1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[5/8 0 1/128 1/16]...
    ,'backgroundcolor',[.75 .75 .75]...
    );
btn23back2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[111/128 0 1/128 1/16]...
    ,'backgroundcolor',[.75 .75 .75]...
    );
btn23=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[81/128 0 30/128 1/16]...
    ,'fontname',font_for_UI...
    ,'backgroundcolor','w'...
    ,'string','Run And Save'...
    ,'fontsize',large_font...
    ,'callback',{@setup,2}...
    );

%-----------Shows Save File Name On UI Once Run Is Started-----------
btn65a=uicontrol('parent',fh1...
    ,'style','text'...
    ,'units','normal'...
    ,'position',[0 1/32 1/2 1/32]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','left'...
    ,'backgroundcolor','w'...
    ,'string',{'Save File Name'}...
    ,'fontsize',medium_font...
    );
btn65b=uicontrol('parent',fh1...
    ,'style','edit'...
    ,'units','normal'...
    ,'position',[0 0 1/2 1/32]...
    ,'fontname',font_for_UI...
    ,'horizontalalignment','left'...
    ,'backgroundcolor','w'...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,2,0}...
    ,'string',' --- '...
    ,'fontsize',medium_font...
    );
%-------------------------------------------------------------------
%--------------------------Runs Simulation--------------------------
%-------------------------------------------------------------------
btn35back1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[1/2 0 1/128 1/16]...
    ,'backgroundcolor',[.75 .75 .75]...
    );
btn35back2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[79/128 0 1/128 1/16]...
    ,'backgroundcolor',[.75 .75 .75]...
    );
btn35=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[65/128 0 7/64 1/16]...
    ,'fontname',font_for_UI...
    ,'backgroundcolor','w'...
    ,'string','Run'...
    ,'fontsize',large_font...
    ,'callback',{@setup,1}...
    );
%---------------------------------------------------------------------
%---------------------------Change Fontsize---------------------------
%---------------------------------------------------------------------
%Allows Selection of Fontsize For Simulation
btn72aback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[0 15/16 1/128 1/16]...
    ,'backgroundcolor','g'...
    );
btn72aback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[15/128 15/16 1/128 1/16]...
    ,'backgroundcolor','g'...
    );
btn72bback1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[16/128 15/16 1/128 1/16]...
    ,'backgroundcolor','w'...
    );
btn72bback2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[31/128 15/16 1/128 1/16]...
    ,'backgroundcolor','w'...
    );
btn72a=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[1/128 15/16 7/64 1/16]...
    ,'style','pushbutton'...
    ,'string',{'Desktop Fonts'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,0,1}...
    );
btn72b=uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[17/128 15/16 7/64 1/16]...
    ,'style','pushbutton'...
    ,'string',{'Laptop Fonts'}...
    ,'fontname',font_for_UI...
    ,'fontsize',small_font...
    ,'callback',{@valueupdator,0,0,0,0,0,0,0,0,0,2}...
    );

%--------------------------------------------------------------------
%--------------------------Stops Simulation--------------------------
%--------------------------------------------------------------------
btn66back1 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[7/8 0 1/128 1/16]...
    ,'backgroundcolor',[.75 .75 .75]...
    );
btn66back2 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'style','pushbutton'...
    ,'enable','off'...
    ,'position',[127/128 0 1/128 1/16]...
    ,'backgroundcolor',[.75 .75 .75]...
    );
btn66 = uicontrol('parent',fh1...
    ,'units','normal'...
    ,'position',[113/128 0 7/64 1/16]...
    ,'fontname',font_for_UI...
    ,'backgroundcolor','w'...
    ,'foregroundcolor','k'...
    ,'string','Stop'...
    ,'fontsize',large_font...
    ,'callback',{@valueupdator,0,0,0,0,0,1,0,0,0,0}...
    );

%------------------------------------------------------------------------
%--------------------------Initial Value Update--------------------------
%------------------------------------------------------------------------
%Runs Value Updator initially so that the code can be run in defualt
%settings
valueupdator(0,0,0,1,1,1,7,0,1,1,1,1)
%-------------------------------------------------------------------
%-------------------------------------------------------------------
%---------------Allows Sliders To Update Run Settings---------------
%-------------------------------------------------------------------
%-------------------------------------------------------------------

%This Section Updates the Run Settings When UI Is Used

    function valueupdator(~,~,update,runtype,spawntype,...
                          herd_1_rule,herd_2_rule,stop,uiplottype,...
                          updateduringrun,updateviatext,updatefontsize)
                      
if update == 0
        if runinprogress == 1 
            
%Update Current Simulation Type (Fix Later With Value Update Section)
if runtype ~= 0 && runinprogress == 1
    simulationtype = runtype; 
end
%Update Usage of Standard Herd
if spawntype ~= 0 && runinprogress == 1
    usestandardherd = spawntype;  
end
%Updates Value For Herd 1 Movement Rule
if herd_1_rule ~= 0 && runinprogress == 1
    herdmovementrule = herd_1_rule;
end
%Updates Value For Herd 2 Movement Rule
if herd_2_rule ~= 0
    herdmovementrule2 = herd_2_rule;
end
%Update Desired Plot Value
if uiplottype ~= 0
ui_plot_desired = uiplottype;
end
%Update Fontsize
if updatefontsize ~= 0
change_font_size = updatefontsize;
end
%---------------------------------------------------------------
%-----------------------Updates Font Size-----------------------
%---------------------------------------------------------------
%Changes Font Size For UI
if change_font_size == 1
    %Update Values
    large_font = 32; %32 24
    medium_font = 16; %16 12
    small_font = 12; %12 8
    %Change Active Buttons
    set(btn72a,'backgroundcolor','w','enable','inactive',...
        'fontsize',small_font)
    set(btn72aback1,'backgroundcolor',[0 1 0]);
    set(btn72aback2,'backgroundcolor',[0 1 0]);
    set(btn72b,'backgroundcolor','w','enable','on',...
        'fontsize',small_font)
    set(btn72bback1,'backgroundcolor',[.75 .75 .75]);
    set(btn72bback2,'backgroundcolor',[.75 .75 .75]);
elseif change_font_size == 2
    %Update Values
    large_font = 24; 
    medium_font = 12; 
    small_font = 10; 
    %Change Active Buttons
    set(btn72a,'backgroundcolor','w','enable','on',...
        'fontsize',small_font)
    set(btn72aback1,'backgroundcolor',[.75 .75 .75]);
    set(btn72aback2,'backgroundcolor',[.75 .75 .75]);
    set(btn72b,'backgroundcolor','w','enable','inactive',...
        'fontsize',small_font)
    set(btn72bback1,'backgroundcolor',[0 1 0]);
    set(btn72bback2,'backgroundcolor',[0 1 0]);
end
%Applies Updates To UI Fonts
btns_large_font = [btn1; btn2; btn3; btn6; btn40; btn7; btn18; btn36;...
                   btn36; btn19; btn67a; btn67b; btn_title_output;...
                   btn61; btn62b; btn63b; btn64b; btn23; btn35; btn66;...
                   btn10];
btns_medium_font = [btn4; btn22; btn38; btn8; btn16; btn37; btn41;...
                    btn304; btn45; btn60; btn62a; btn63a; btn64a;...
                    btn65a; btn65b];
btns_small_font = [btn22a; btn22b; btn42a; btn42b; btn12a; btn12b;...
                   btn12c; btn12d; btn46a; btn46b; btn46c; btn46d;...
                   btn_66a; btn_66b];
set(btns_large_font,'fontsize',large_font)
set(btns_medium_font,'fontsize',medium_font)
set(btns_small_font,'fontsize',small_font)
%---------------------------------------------------------------
%---------------------Updates herd Settings---------------------
%---------------------------------------------------------------

%-----------Allows Number Of Prey Following Movement Rule 1 To Be Selected
%Updates Slider
if updateviatext == 1
        herdmovementrule_1 = round(get(btn5,'value'));
        set(btn6, 'String', num2str(herdmovementrule_1));
elseif updateviatext == 2
%Checks If Text Was Imputed Instead Of A Number 
btn6_str = get(btn6,'String');
if isempty(str2num(btn6_str))
    set(btn6,'string',num2str(herdmovementrule_1));
elseif (str2num(btn6_str) < 1) || (str2num(btn6_str) > 100) || ...
       (mod(str2num(btn6_str),1) ~= 0)
    set(btn6,'string',num2str(herdmovementrule_1))
else
    herdmovementrule_1 = str2num(btn6_str);
    set(btn5,'value',herdmovementrule_1)
end
end

%-----------Allows Number Of Prey Following Movement Rule 2 To Be Selected
%Updates Slider
if updateviatext == 1
        herdmovementrule_2 = round(get(btn39,'value'));
        set(btn40, 'String', num2str(herdmovementrule_2));
elseif updateviatext == 2
%Checks If Text Was Imputed Instead Of A Number 
btn40_str = get(btn40,'String');
if isempty(str2num(btn40_str))
    set(btn40,'string',num2str(herdmovementrule_2));
elseif (str2num(btn40_str) < 0) || (str2num(btn40_str) > 100)  || ...
       (mod(str2num(btn40_str),1) ~= 0)
    set(btn40,'string',num2str(herdmovementrule_2));
else
    herdmovementrule_2 = str2num(btn40_str);
    set(btn39,'value',herdmovementrule_2)
end
end
%-----------Switches to Standard Herd
if spawntype ~= 0
usestandardherd = spawntype;  
%If The Reference Heard is Not In Use
if usestandardherd == 1
    set(btn22a,'backgroundcolor','w','enable','inactive')
    set(btn22a_ind1,'backgroundcolor',[0 1 0]);
    set(btn22a_ind2,'backgroundcolor',[0 1 0]);
    set(btn22b,'backgroundcolor','w','enable','on')
    set(btn22b_ind1,'backgroundcolor',[.75 .75 .75]);
    set(btn22b_ind2,'backgroundcolor',[.75 .75 .75]);
    set(btn5,'enable','on')
    if simulationtype == 1   
    set(btn39,'enable','off')
    elseif simulationtype == 2   
    set(btn39,'enable','on')
    end
%Unlocks Imputs
set(btn6,'enable','on')
if simulationtype == 2
set(btn40,'enable','on')    
end
%If The Reference Heard Is Used
elseif usestandardherd == 2
    set(btn22a,'backgroundcolor','w','enable','on')
    set(btn22a_ind1,'backgroundcolor',[.75 .75 .75]);
    set(btn22a_ind2,'backgroundcolor',[.75 .75 .75]);
    set(btn22b,'backgroundcolor','w','enable','inactive')
    set(btn22b_ind1,'backgroundcolor',[0 1 0]);
    set(btn22b_ind2,'backgroundcolor',[0 1 0]);
%Sets Up Heard Numbers For DOD Simulations
    if simulationtype == 1   
    set(btn5,'value',100);
    set(btn5,'enable','off') 
    set(btn39,'value',0);
    set(btn39,'enable','off')
%Sets Up Heard Numbers For Mixed Heard Simulations
    elseif simulationtype == 2
    set(btn5,'value',50);
    set(btn5,'enable','off') 
    set(btn39,'value',50);
    set(btn39,'enable','off')    
    end
%Outputs Current Value To UI  
    herdmovementrule_1 = round(get(btn5,'value'));
    set(btn6, 'String', num2str(herdmovementrule_1))
    herdmovementrule_2 = round(get(btn39,'value'));
    set(btn40, 'String', num2str(herdmovementrule_2))
%Locks Down Imputs
set(btn6,'enable','inactive')
set(btn40,'enable','inactive')
end
end
        
        
%-----------Updates Herd Movement Rules-----------
%First Herd Rule Update (Also Will Update Mixed Herd Output If That
%Simulation Type Is Selected)
if herd_1_rule ~= 0
herdmovementrule = herd_1_rule;
if herdmovementrule == 1
    %Deactivates Pressed Button
    set(btn12a,'enable','inactive')
    set(btn12b,'enable','on')
    set(btn12c,'enable','on')
    set(btn12d,'enable','on')
    %Turns The Indicator Light Of The Pressed button To Green The Rest Gray
    set(btn12aback1,'backgroundcolor',[0 1 0])
    set(btn12aback2,'backgroundcolor',[0 1 0])
    set(btn12bback1,'backgroundcolor',[.75 .75 .75])
    set(btn12bback2,'backgroundcolor',[.75 .75 .75])
    set(btn12cback1,'backgroundcolor',[.75 .75 .75])
    set(btn12cback2,'backgroundcolor',[.75 .75 .75])
    set(btn12dback1,'backgroundcolor',[.75 .75 .75])
    set(btn12dback2,'backgroundcolor',[.75 .75 .75])
    if simulationtype == 2
    set(btn60,'string',{'# of Dead', 'LCH'})
    rule_1_string = 'LCH';
    end
elseif herdmovementrule == 2
    %Deactivates Pressed Button
    set(btn12a,'enable','on')
    set(btn12b,'enable','inactive')
    set(btn12c,'enable','on')
    set(btn12d,'enable','on')
    %Turns The Indicator Light Of The Pressed button To Green The Rest Gray
    set(btn12aback1,'backgroundcolor',[.75 .75 .75])
    set(btn12aback2,'backgroundcolor',[.75 .75 .75])
    set(btn12bback1,'backgroundcolor',[0 1 0])
    set(btn12bback2,'backgroundcolor',[0 1 0])
    set(btn12cback1,'backgroundcolor',[.75 .75 .75])
    set(btn12cback2,'backgroundcolor',[.75 .75 .75])
    set(btn12dback1,'backgroundcolor',[.75 .75 .75])
    set(btn12dback2,'backgroundcolor',[.75 .75 .75])
    if simulationtype == 2
    set(btn60,'string',{'# Of Dead','LCH + Noise'})  
    rule_1_string = 'LCH + Noise';
    end
elseif herdmovementrule == 3
    %Deactivates Pressed Button
    set(btn12a,'enable','on')
    set(btn12b,'enable','on')
    set(btn12c,'enable','inactive')
    set(btn12d,'enable','on')
    %Turns The Indicator Light Of The Pressed button To Green The Rest Gray
    set(btn12aback1,'backgroundcolor',[.75 .75 .75])
    set(btn12aback2,'backgroundcolor',[.75 .75 .75])
    set(btn12bback1,'backgroundcolor',[.75 .75 .75])
    set(btn12bback2,'backgroundcolor',[.75 .75 .75])
    set(btn12cback1,'backgroundcolor',[0 1 0])
    set(btn12cback2,'backgroundcolor',[0 1 0])
    set(btn12dback1,'backgroundcolor',[.75 .75 .75])
    set(btn12dback2,'backgroundcolor',[.75 .75 .75])
    if simulationtype == 2
    set(btn60,'string',{'# Of Dead','Voronoi'})
    rule_1_string = 'Voronoi';
    end
elseif herdmovementrule == 4
    %Deactivates Pressed Button
    set(btn12a,'enable','on')
    set(btn12b,'enable','on')
    set(btn12c,'enable','on')
    set(btn12d,'enable','inactive')
    %Turns The Indicator Light Of The Pressed button To Green The Rest Gray
    set(btn12aback1,'backgroundcolor',[.75 .75 .75])
    set(btn12aback2,'backgroundcolor',[.75 .75 .75])
    set(btn12bback1,'backgroundcolor',[.75 .75 .75])
    set(btn12bback2,'backgroundcolor',[.75 .75 .75])
    set(btn12cback1,'backgroundcolor',[.75 .75 .75])
    set(btn12cback2,'backgroundcolor',[.75 .75 .75])
    set(btn12dback1,'backgroundcolor',[0 1 0])
    set(btn12dback2,'backgroundcolor',[0 1 0])
    if simulationtype == 2
    set(btn60,'string',{'# Of Dead','Voronoi + Noise'})
    rule_1_string = 'Voronoi + Noise';
    end
end
%updates X Axis Tickmark Lables If Doing Mixed Herd Simulation
if simulationtype == 2
set(main_figure_plot_axes, ...
        'fontsize',12,...
        'xticklabel',({rule_1_string, rule_2_string}))
end
end

%First Herd
if herd_2_rule ~= 0
herdmovementrule2 = herd_2_rule;
if herdmovementrule2 == 5
    %Deactivates Pressed Button
    set(btn46a,'enable','inactive')
    set(btn46b,'enable','on')
    set(btn46c,'enable','on')
    set(btn46d,'enable','on')
    %Turns The Indicator Light Of The Pressed button To Green The Rest Gray
    set(btn46aback1,'backgroundcolor',[0 1 0])
    set(btn46aback2,'backgroundcolor',[0 1 0])
    set(btn46bback1,'backgroundcolor',[.75 .75 .75])
    set(btn46bback2,'backgroundcolor',[.75 .75 .75])
    set(btn46cback1,'backgroundcolor',[.75 .75 .75])
    set(btn46cback2,'backgroundcolor',[.75 .75 .75])
    set(btn46dback1,'backgroundcolor',[.75 .75 .75])
    set(btn46dback2,'backgroundcolor',[.75 .75 .75])
    if simulationtype == 2
    set(btn62a,'string',{'# of Dead', 'LCH'})  
    rule_2_string = 'LCH';
    end
elseif herdmovementrule2 == 6
    %Deactivates Pressed Button
    set(btn46a,'enable','on')
    set(btn46b,'enable','inactive')
    set(btn46c,'enable','on')
    set(btn46d,'enable','on')
    %Turns The Indicator Light Of The Pressed button To Green The Rest Gray
    set(btn46aback1,'backgroundcolor',[.75 .75 .75])
    set(btn46aback2,'backgroundcolor',[.75 .75 .75])
    set(btn46bback1,'backgroundcolor',[0 1 0])
    set(btn46bback2,'backgroundcolor',[0 1 0])
    set(btn46cback1,'backgroundcolor',[.75 .75 .75])
    set(btn46cback2,'backgroundcolor',[.75 .75 .75])
    set(btn46dback1,'backgroundcolor',[.75 .75 .75])
    set(btn46dback2,'backgroundcolor',[.75 .75 .75])
    if simulationtype == 2
    set(btn62a,'string',{'# Of Dead','LCH + Noise'}) 
    rule_2_string = 'LCH + Noise';
    end
elseif herdmovementrule2 == 7
    %Deactivates Pressed Button
    set(btn46a,'enable','on')
    set(btn46b,'enable','on')
    set(btn46c,'enable','inactive')
    set(btn46d,'enable','on')
    %Turns The Indicator Light Of The Pressed button To Green The Rest Gray
    set(btn46aback1,'backgroundcolor',[.75 .75 .75])
    set(btn46aback2,'backgroundcolor',[.75 .75 .75])
    set(btn46bback1,'backgroundcolor',[.75 .75 .75])
    set(btn46bback2,'backgroundcolor',[.75 .75 .75])
    set(btn46cback1,'backgroundcolor',[0 1 0])
    set(btn46cback2,'backgroundcolor',[0 1 0])
    set(btn46dback1,'backgroundcolor',[.75 .75 .75])
    set(btn46dback2,'backgroundcolor',[.75 .75 .75])
    if simulationtype == 2
    set(btn62a,'string',{'# Of Dead', 'Voronoi'})    
    rule_2_string = 'Voronoi';
    end
elseif herdmovementrule2 == 8
    %Deactivates Pressed Button
    set(btn46a,'enable','on')
    set(btn46b,'enable','on')
    set(btn46c,'enable','on')
    set(btn46d,'enable','inactive')
    %Turns The Indicator Light Of The Pressed button To Green The Rest Gray
    set(btn46aback1,'backgroundcolor',[.75 .75 .75])
    set(btn46aback2,'backgroundcolor',[.75 .75 .75])
    set(btn46bback1,'backgroundcolor',[.75 .75 .75])
    set(btn46bback2,'backgroundcolor',[.75 .75 .75])
    set(btn46cback1,'backgroundcolor',[.75 .75 .75])
    set(btn46cback2,'backgroundcolor',[.75 .75 .75])
    set(btn46dback1,'backgroundcolor',[0 1 0])
    set(btn46dback2,'backgroundcolor',[0 1 0])
    if simulationtype == 2
    set(btn62a,'string',{'# Of Dead','Voronoi + Noise'}) 
    rule_2_string = 'Voronoi + Noise';
    end
end
%updates X Axis Tickmark Lables If Doing Mixed Herd Simulation
if simulationtype == 2
set(main_figure_plot_axes, ...
        'fontsize',12,...
        'xticklabel',({rule_1_string, rule_2_string}))
end
end
%----------------------------------------------------------------        
%---------------------Updates Noise Settings---------------------
%----------------------------------------------------------------
%----Changes Noise Value
%Updates Slider
if updateviatext == 1
        noiseweight = get(btn34,'value');
        set(btn36, 'String', num2str(round(noiseweight,2)));
        set(btn34,'value',noiseweight);    
elseif updateviatext == 2
%Checks If Text Was Imputed Instead Of A Number 
btn36_str = get(btn36,'String');
if isempty(str2num(btn36_str))
    set(btn36,'string',num2str(noiseweight));
elseif (str2num(btn36_str) < 0) || (str2num(btn36_str) > 5)
    set(btn36,'string',num2str(noiseweight));
else
    noiseweight = str2num(btn36_str);
    set(btn34,'value',noiseweight)
end
end

%----Locks Slider And Text If No Movement Rulese Use Noise
if (mod(herdmovementrule,2) ~= 0 && mod(herdmovementrule2,2) ~= 0) || ...
   (mod(herdmovementrule,2) ~= 0 && simulationtype == 1)

%If No Noise Is Used
set(btn36,'enable','inactive','string',num2str(0))
set(btn34,'enable','off','value',0)
noiseweight = -1;
elseif (((mod(herdmovementrule,2) == 0 || ...
       (mod(herdmovementrule2,2) == 0 && simulationtype == 2))) ...
       && noiseweight == -1)
%If Noise Is Used
noiseweight = 1;
set(btn36,'String',num2str(noiseweight),'enable','on');
set(btn34,'value',noiseweight,'enable','on');    
end
%---------------------------------------------------------------        
%------------------Updates Simulation Settings------------------
%---------------------------------------------------------------

%-----------Updates Value For Timesteps-----------
%Changes The Number Of Timesteps For Each Run Based on The Value Of The
%Slider
if updateviatext == 1
        timesteps = roundn(get(btn9,'value'),1);
        set(btn10, 'String', num2str(timesteps));
elseif updateviatext == 2
%Checks If Text Was Imputed Instead Of A Number 
btn10_str = get(btn10,'String');
if isempty(str2num(btn10_str))
    set(btn10,'string',num2str(timesteps));
elseif (str2num(btn10_str) < 10) || (str2num(btn10_str) > 5000) || ...
       (mod(str2num(btn10_str),1) ~= 0)
    set(btn10,'string',num2str(timesteps));
else
    timesteps = str2num(btn10_str);
    set(btn9,'value',timesteps)
end
end
        
%-----------Updates Number Of Runs-----------
%Changes The Number Of Runs For Each Simulation Based On The Value Of The
%Slider
if updateviatext == 1
        numberofruns = round(get(btn17,'value'));
        set(btn18, 'String', num2str(numberofruns));
elseif updateviatext == 2
%Checks If Text Was Imputed Instead Of A Number 
btn18_str = get(btn18,'String');
if isempty(str2num(btn18_str))
    set(btn18,'string',num2str(numberofruns));
elseif (str2num(btn18_str) < 1) || (str2num(btn18_str) > 1000) || ...
       (mod(str2num(btn18_str),1) ~= 0)
    set(btn18,'string',num2str(numberofruns));
else
    numberofruns = str2num(btn18_str);
    set(btn17,'value',numberofruns)
end
end       
        
        
        end
%-------------------------------------------------------------------        
%----------------------Updates Simulation Type----------------------
%-------------------------------------------------------------------
%Based On The Button Pressed This Section Of Code Will Change The Color of
%The Two Buttons Controlling Simulation Type So That The One That Was
%Pressed Last Is Green And The Other Is White. Then If Thhe Standard Herd 
%Is Not In Use Sets The Second Herd To Have 0 Members If It Is A DOD
%Run And 50 For A Mixed Herd Run. If The Standard Herd Is
%Being Used The Values For Number Of Memebrs In Each Herd Are Set
%Accordingly. 
if runtype ~= 0 && runinprogress == 1
simulationtype = runtype;   
%For DOD Runs
if runtype == 1 && runinprogress == 1
    set(btn42a,'backgroundcolor','w','enable','inactive')
    set(btn42aback1,'backgroundcolor',[0 1 0])
    set(btn42aback2,'backgroundcolor',[0 1 0])
    set(btn42b,'backgroundcolor','w','enable','on')
    set(btn42bback1,'backgroundcolor',[.75 .75 .75])
    set(btn42bback2,'backgroundcolor',[.75 .75 .75])
    if usestandardherd == 1
        set(btn5,'value',100);
    set(btn39,'value',0,'enable','off');
    set(btn40,'enable','inactive')
    herdmovementrule_1 = round(get(btn5,'value'));
    set(btn6, 'String', num2str(herdmovementrule_1))
    herdmovementrule_2 = round(get(btn39,'value'));
    set(btn40, 'String', num2str(herdmovementrule_2))  
    elseif usestandardherd == 2
    set(btn5,'value',100);
    set(btn39,'value',0,'enable','off');
    set(btn40,'enable','inactive')
    herdmovementrule_1 = round(get(btn5,'value'));
    set(btn6, 'String', num2str(herdmovementrule_1))
    herdmovementrule_2 = round(get(btn39,'value'));
    set(btn40, 'String', num2str(herdmovementrule_2)) 
    end
% Deactivates Second Herd Movement Rule Selection
    %Deactivates Buttons
    set(btn46a,'enable','inactive')
    set(btn46b,'enable','inactive')
    set(btn46c,'enable','inactive')
    set(btn46d,'enable','inactive')
    %Turns The Indicator Light Of The Buttons To Gray
    set(btn46aback1,'backgroundcolor',[.75 .75 .75])
    set(btn46aback2,'backgroundcolor',[.75 .75 .75])
    set(btn46bback1,'backgroundcolor',[.75 .75 .75])
    set(btn46bback2,'backgroundcolor',[.75 .75 .75])
    set(btn46cback1,'backgroundcolor',[.75 .75 .75])
    set(btn46cback2,'backgroundcolor',[.75 .75 .75])
    set(btn46dback1,'backgroundcolor',[.75 .75 .75])
    set(btn46dback2,'backgroundcolor',[.75 .75 .75])    
%For Mixed Herd Runs
elseif runtype == 2 && runinprogress == 1
    set(btn42a,'backgroundcolor','w','enable','on')
    set(btn42aback1,'backgroundcolor',[.75 .75 .75])
    set(btn42aback2,'backgroundcolor',[.75 .75 .75])
    set(btn42b,'backgroundcolor','w','enable','inactive')
    set(btn42bback1,'backgroundcolor',[0 1 0])
    set(btn42bback2,'backgroundcolor',[0 1 0])
    if usestandardherd == 1
    set(btn5,'value',50);
    set(btn39,'value',50,'enable','on');
    herdmovementrule_1 = round(get(btn5,'value'));
    set(btn6, 'String', num2str(herdmovementrule_1))
    herdmovementrule_2 = round(get(btn39,'value'));
    set(btn40, 'String', num2str(herdmovementrule_2))  
    elseif usestandardherd == 2
    set(btn5,'value',50);
    set(btn39,'value',50,'enable','off');
    herdmovementrule_1 = round(get(btn5,'value'));
    set(btn6, 'String', num2str(herdmovementrule_1))
    herdmovementrule_2 = round(get(btn39,'value'));
    set(btn40, 'String', num2str(herdmovementrule_2))    
    end
    % Reactivates Second Herd Movement Rule Selection
    %Reactivates Buttons
    set(btn46a,'enable','on')
    set(btn46b,'enable','on')
    set(btn46c,'enable','on')
    set(btn46d,'enable','on')   
    %Unlocks Imputs
    if usestandardherd == 1
    set(btn40,'enable','on')    
    end
    %Sets Current Second Herd Movement Rule Button To Green And inactive
    if herdmovementrule2 == 5
    set(btn46a,'enable','inactive')
    set(btn46aback1,'backgroundcolor',[0 1 0])
    set(btn46aback2,'backgroundcolor',[0 1 0])
     
    elseif herdmovementrule2 == 6
    set(btn46b,'enable','inactive')
    set(btn46bback1,'backgroundcolor',[0 1 0])
    set(btn46bback2,'backgroundcolor',[0 1 0])
    
    elseif herdmovementrule2 == 7
    set(btn46c,'enable','inactive')
    set(btn46cback1,'backgroundcolor',[0 1 0])
    set(btn46cback2,'backgroundcolor',[0 1 0])
    
    elseif herdmovementrule2 == 8
    set(btn46d,'enable','inactive')
    set(btn46dback1,'backgroundcolor',[0 1 0])
    set(btn46dback2,'backgroundcolor',[0 1 0]) 
    end
end
end

%-----------------------------------------------------------------------        
%----------------Changes UI Plot Based On Output Desired----------------
%-----------------------------------------------------------------------
%Based On Changes To Run Type This Section Will Change The Data Output On
%The UI Before The Simulation Starts To Give The User An Idea On How The
%Data Will Be Output. if The Current Animation Is Desired During A Run
%Instead of Run Data That Will Be Shown Instead. Works During Runs.

if runinprogress == 1 || ...
  (runinprogress == 2 && updateduringrun == 1 && stop == 0)

%------Changes Between Run Data And Animation For Plot
if uiplottype ~= 0
ui_plot_desired = uiplottype;
if ui_plot_desired == 1
%Deactivates Pressed Button
       set(btn_66a,'enable','inactive') 
       set(btn_66b,'enable','on')
%Turns The Indicator Light Of The Pressed button To Green The Rest Gray
       set(btn66aback1,'backgroundcolor',[0 1 0])
       set(btn66aback2,'backgroundcolor',[0 1 0])
       set(btn66bback1,'backgroundcolor',[.75 .75 .75])
       set(btn66bback2,'backgroundcolor',[.75 .75 .75])
elseif ui_plot_desired == 2
%Deactivates Pressed Button
       set(btn_66a,'enable','on') 
       set(btn_66b,'enable','inactive')
%Turns The Indicator Light Of The Pressed button To Green The Rest Gray
       set(btn66aback1,'backgroundcolor',[.75 .75 .75])
       set(btn66aback2,'backgroundcolor',[.75 .75 .75])
       set(btn66bback1,'backgroundcolor',[0 1 0])
       set(btn66bback2,'backgroundcolor',[0 1 0])
end
end
%Turns On Or Off Symbol Key For Non Mixed Heard Animations Based On
%Settings
if simulationtype == 1 || (simulationtype == 2 && ui_plot_desired == 1)
    set(btn67a,'visible','off')
    set(btn67b,'visible','off')
elseif simulationtype == 2
    set(btn67a,'visible','on')
    set(btn67b,'visible','on')
end
%First Determin If Simulationtype Has Changed Or If The Last Animation Is
%The Desired UI Output
if runtype ~= 0 || ui_plot_desired ~= 0

%Allows Desired Output To be A Graphical Representation Of The Data

%If Simulation Type Has Changed Based On Type Of Simulation Desired, Change
%UI Plots To Mirror Desired Output
if simulationtype == 1 && runinprogress == 1
    
%Sets Up UI To Output DOD Information
    set(btn_title_output,'string','DOD Run')
    set(btn60,'string','Avg. % of Herd Improving DOD')
    set(btn61, 'String',...
        num2str(round(mean_percentofherdmemberswithdecreasing_dod,2))); 
    set(btn62a,'string',{'Standard', 'Deviation'})
    set(btn62b, 'String',...
        num2str(round(std_percentofherdmemberswithdecreasing_dod,2)));     
    bar(main_figure_plot_axes,1:100,...
    sorted_percentofherdmemberswithdecreasing_dod) 

%Changes Axis Based On If Data Has Been Collected Or Not
if sum(sorted_percentofherdmemberswithdecreasing_dod) == 0
    axis(main_figure_plot_axes, [0 100 0 100])
%Sets Up Tick marks
    set(main_figure_plot_axes, ...      
        'xticklabelmode','auto',...
        'xtick',0:10:100,...
        'fontsize',small_font);
elseif sum(sorted_percentofherdmemberswithdecreasing_dod) ~= 0
firstnon_0 = find(sorted_percentofherdmemberswithdecreasing_dod,1,'first');
lastnon_0 = find(sorted_percentofherdmemberswithdecreasing_dod,1,'last');
axis(main_figure_plot_axes, ...
[(firstnon_0 - 5) (lastnon_0 + 5) ...
 0 (max(sorted_percentofherdmemberswithdecreasing_dod) + 5)]) 
%Sets Up Tick marks
set(main_figure_plot_axes, ...      
        'xticklabelmode','auto',...
        'xtick',(firstnon_0 - 5):5:(lastnon_0 + 5),...
        'fontsize',small_font);
end

%Sets Up Axis Labels
    xlabel('Percent of Herd Improving DOD','fontsize',medium_font)
    ylabel('Cumulative Statistics','fontsize',medium_font)
                                                     
elseif (simulationtype == 2 && runinprogress == 1)
    %Sets Up UI To Output Mixed Herd Info
    
    %Sets Basic Values
    set(btn_title_output,'string','Mixed Herd Run')    
    set(btn61, 'String', num2str(total_deaths_rule_1));
    set(btn62b, 'String', num2str(total_deaths_rule_2)); 
    
    %Stes Up UI With Elements That Change Based On Movement Rule Selected
    
    %Sets Up Output For First Movement Rule
    if herdmovementrule == 1
    set(btn60,'string',{'# Of Dead', 'LCH'})  
    rule_1_string = 'Herd 1: LCH';
    elseif herdmovementrule == 2
    set(btn60,'string',{'# Of Dead','LCH + Noise'})  
    rule_1_string = 'Herd 1: LCH + Noise';
    elseif herdmovementrule == 3
    set(btn60,'string',{'# Of Dead', 'Voronoi'})   
    rule_1_string = 'Herd 1: Voronoi';
    elseif herdmovementrule == 4
    set(btn60,'string',{'# Of Dead','Voronoi + Noise'})   
    rule_1_string = 'Herd 1: Voronoi + Noise';
    end
    
    %Sets Up Output For Second Movement Rule
    if herdmovementrule2 == 5
    set(btn62a,'string',{'# Of Dead', 'LCH'})  
    rule_2_string = 'Herd 2: LCH';
    elseif herdmovementrule2 == 6
    set(btn62a,'string',{'# Of Dead','LCH + Noise'})   
    rule_2_string = 'Herd 2: LCH + Noise';
    elseif herdmovementrule2 == 7
    set(btn62a,'string',{'# Of Dead', 'Voronoi'})
    rule_2_string = 'Herd 2: Voronoi';
    elseif herdmovementrule2 == 8
    set(btn62a,'string',{'# Of Dead','Voronoi + Noise'})   
    rule_2_string = 'Herd 2: Voronoi + Noise';
    end
    %Based On Movement Rules Selected Sets Up A String Output For Rules To
    %Be Used In The Bar Graph As labels For The Axis
    bar(main_figure_plot_axes,1:2,...
    [total_deaths_rule_1 total_deaths_rule_2]) 
axis(main_figure_plot_axes, [0 3 ...
        0 (max([total_deaths_rule_1 total_deaths_rule_2]) + 5)])
    set(main_figure_plot_axes, ...
        'fontsize',small_font,...
        'xticklabel',({rule_1_string, rule_2_string}),...
        'xtick',[1 2])
    xlabel('Herd Movement Rules','fontsize',medium_font)
    ylabel('Number of Dead Prey','fontsize',medium_font)
    
elseif ui_plot_desired == 1 && runinprogress == 2   

%If Run Is Underway And The Bar Graph Output Is Desired Over The
%Animation
    
 if simulationtype == 1
%Sets Data Output Back To A Histogram For DOD Runs        
        bar(main_figure_plot_axes,1:100,...
    sorted_percentofherdmemberswithdecreasing_dod) 

%Changes Axis Based On If Data Has Been Collected Or Not
if sum(sorted_percentofherdmemberswithdecreasing_dod) == 0
    axis(main_figure_plot_axes, [0 100 0 100])
%Sets Up Tick marks
    set(main_figure_plot_axes, ...      
        'xticklabelmode','auto',...
        'xtick',0:10:100,...
        'fontsize',small_font);
elseif sum(sorted_percentofherdmemberswithdecreasing_dod) ~= 0
firstnon_0 = find(sorted_percentofherdmemberswithdecreasing_dod,1,'first');
lastnon_0 = find(sorted_percentofherdmemberswithdecreasing_dod,1,'last');
axis(main_figure_plot_axes, ...
[(firstnon_0 - 5) (lastnon_0 + 5) ...
 0 (max(sorted_percentofherdmemberswithdecreasing_dod) + 5)]) 
%Sets Up Tick marks
set(main_figure_plot_axes, ...      
        'xticklabelmode','auto',...
        'xtick',(firstnon_0 - 5):5:(lastnon_0 + 5),...
        'fontsize',small_font);
end

%Sets Up Axis Labels
    xlabel('Percent of Herd Improving DOD','fontsize',medium_font)
    ylabel('Cumulative Statistics','fontsize',medium_font)
    
 elseif simulationtype == 2
        
%Sets up Mixed Herd Bar Graph
    bar(main_figure_plot_axes,1:2,...
    [total_deaths_rule_1 total_deaths_rule_2]) 
    axis(main_figure_plot_axes, [0 3 ...
        0 (max([total_deaths_rule_1 total_deaths_rule_2]) + 5)])
    set(main_figure_plot_axes, ...
        'fontsize',small_font,...
        'xticklabel',({rule_1_string, rule_2_string}),...
        'xtick',[1 2])
    xlabel('Herd Movement Rules','fontsize',medium_font)
    ylabel('Number of Dead Prey','fontsize',medium_font)
    
 end
end
%Sets Up Animtion Output If Desired 
if ui_plot_desired == 2
%Sets up Plot
plot(main_figure_plot_axes,plot_info_storage)
axis(main_figure_plot_axes,[0 360 ...
       0 360])
%Sets Up Tick marks
    set(main_figure_plot_axes, ...      
        'xticklabelmode','auto',...
        'xtick',(0:50:360),...
        'yticklabelmode','auto',...
        'ytick',(0:50:360),...
        'fontsize',small_font);
    xlabel(' ','fontsize',medium_font)
    ylabel(' ','fontsize',medium_font)

%Plots Based On Settings
if (simulationtype == 1 && herdmemberinformation(1,1) ~= 0) && ...
   (type_of_data_collected ~= 2)
%Plots Voronoi Tesselation
    voronoi(main_figure_plot_axes,...
    [transpose(herdmemberinformation(...
    (herdmemberinformation(:,1)~=0),1)),...
    transpose(mirrorpoints(:,1))],...
    [transpose(herdmemberinformation(...
    (herdmemberinformation(:,2)~=0),2)),...
    transpose(mirrorpoints(:,2))]);


    axis(main_figure_plot_axes,[0 360 ...
       0 360])    
elseif (simulationtype == 2 && herdmemberinformation(1,1) ~= 0)  && ...
       (type_of_data_collected ~= 1)
%Plots Mixed Herd
 plot(main_figure_plot_axes,herdmemberinformation(1:herdmovementrule_1,1)...
      ,herdmemberinformation(1:herdmovementrule_1,2)...
      ,'x'...
      ,herdmemberinformation((herdmovementrule_1+1):numberofprey,1) ...
      ,herdmemberinformation((herdmovementrule_1+1):numberofprey,2) ...
      ,'+'...
      ,predatorinfo(:,1),predatorinfo(:,2),'mo','markerfacecolor','m');
  hold on
  if mod(timesteps_display,2) == 0
  plot(main_figure_plot_axes,predatorinfo(:,1),predatorinfo(:,2),...
      'm+','markerfacecolor','m','markersize',10)
  else
  plot(main_figure_plot_axes,predatorinfo(:,1),predatorinfo(:,2),...
      'mx','markerfacecolor','m','markersize',12)
  end
   hold off
  axis(main_figure_plot_axes,[0 360 ...
       0 360])
      
end
end
end
end
%-----------------------------------------------------------------------        
%-------------------------Changes Save Filename-------------------------
%-----------------------------------------------------------------------
%Changes The Save Filename To One Selected By The User
if updateviatext == 1
elseif updateviatext == 2
%Notes That a Custom Filename Is In Use
filename_entered = 2;
%Checks If Text Was Imputed Instead Of A Number 
btn65b_str = get(btn65b,'String');
if ~isempty(regexp(btn65b_str, '[/\*?"<>|:]', 'once')) 
    set(btn65b,'string',' --- ')
else
    filename = get(btn65b,'string');
end
end
end

%Stop Button Functionality
if stop ~= 0 && runinprogress == 2
stopsimulation = 2;    
end             
end
%--------------------------------------------------------
%--------------------------------------------------------
%-----------------------Simulation-----------------------
%--------------------------------------------------------
%--------------------------------------------------------

%----------------------------------------------------------------------  
%-------------------------Termination Function-------------------------
%---------------------------------------------------------------------- 
%This Function IS Only Called If Exit Is Pushed Otherwise It Does Not Run
%--terminates Code if Exit is Pushed
function end_code_now(~,~)
    valueupdator(0,0,0,0,0,0,0,1,0,0,0,0)
    close all
    clear all
    numberofprey = 1;
    close_btn_pressed = 2;
    stopsimulation = 2;
    numberofruns = 10000;
    timesteps = 10000;
    return

end

function setup(~,~,save)
%Changes Buttons Indication Colors To Show That A Run Is In Progress And
%Which Type Of Run Is Being Done
if save == 1
set(btn35back1,'backgroundcolor',[0 1 0]);
set(btn35back2,'backgroundcolor',[0 1 0]);
elseif save == 2
set(btn23back1,'backgroundcolor',[0 1 0]);
set(btn23back2,'backgroundcolor',[0 1 0]);   
end
%Sets Stop Button To Ready Values
set(btn66,'backgroundcolor','r','foregroundcolor','w')
set(btn66back1,'backgroundcolor',[.75 .75 .75]);
set(btn66back2,'backgroundcolor',[.75 .75 .75]);
%Locks Down UI Sliders  
set(btn5,'enable','off')
set(btn39,'enable','off')
set(btn34,'enable','off')
set(btn17,'enable','off')
set(btn9,'enable','off')

%Locks Down UI Buttons
%Settings
set(btn72a,'enable','inactive')
set(btn72b,'enable','inactive')
set(btn22a,'enable','inactive')
set(btn22b,'enable','inactive')
set(btn42a,'enable','inactive')
set(btn42b,'enable','inactive')
%First Herd Movement Rules
set(btn12a,'enable','inactive')
set(btn12b,'enable','inactive')
set(btn12c,'enable','inactive')
set(btn12d,'enable','inactive')
%Second Herd Movement Rules
set(btn46a,'enable','inactive')
set(btn46b,'enable','inactive')
set(btn46c,'enable','inactive')
set(btn46d,'enable','inactive')

%Disable UI Imputs And Change The Box To Green
set(btn10,'enable','inactive','foregroundcolor',[0    0.6740    0.1880])
set(btn18,'enable','inactive','foregroundcolor',[0    0.6740    0.1880])
set(btn6,'enable','inactive','foregroundcolor',[0    0.6740    0.1880])
set(btn65b,'enable','inactive')

if mod(herdmovementrule,2) == 0 || mod(herdmovementrule2,2) == 0
set(btn36,'enable','inactive','foregroundcolor',[0    0.6740    0.1880])    
end

%Based on run settings changes 
switch simulationtype
    case 1
set(btn40,'enable','inactive')
    case 2
set(btn40,'enable','inactive','foregroundcolor',[0 0.6740 0.1880])        
end
%Deactivates Run Buttons Until Stop Is Pressed Or The Run Ends
set(btn35,'enable','inactive')
set(btn23,'enable','inactive')

%Resets All Data Output Buttons To Display 0's
set(btn61,'string',num2str(0))
set(btn62b,'string',num2str(0))
set(btn63b,'string',num2str(0))
set(btn64b,'string',num2str(0))

    tic 
%Initializes Storage Variable For DoD Calculation Here

%----------------------------------------------------------------------  
%----------------------Sets up Tracking Variables----------------------
%----------------------------------------------------------------------
%Variables Used To Track Run Info Are Set Up And Reset Here
total_deaths_rule_1 = 0;
total_deaths_rule_2 = 0;
first_herd_deaths = 0;
second_herd_deaths = 0;
totalnumberofpredators = numberofpredators;
savetotxtfile = save;
percentofherdmemberswithdecreasing_dod = 0;
sorted_percentofherdmemberswithdecreasing_dod = zeros(1,100);
mean_percentofherdmemberswithdecreasing_dod = 0;
std_percentofherdmemberswithdecreasing_dod = 0;
herdmemberinformation = [0 0];

%Tracks Data Collection Type
if simulationtype == 1
    type_of_data_collected = 1;
elseif simulationtype == 2
    type_of_data_collected = 2;
end

%Resets Plots

%If Stats Output Is Opened
if ui_plot_desired == 1

%For DOD Stats
if simulationtype == 1
bar(main_figure_plot_axes,1:100,...
    sorted_percentofherdmemberswithdecreasing_dod) 
    axis(main_figure_plot_axes, [0 100 0 100])

%Set Up Axis Labels    
set(main_figure_plot_axes, ...      
        'xticklabelmode','auto',...
        'xtick',0:10:100,...
        'fontsize',small_font);
    xlabel('Percent of Herd Improving DOD','fontsize',medium_font)
    ylabel('Cumulative Statistics','fontsize',medium_font)
    
%For Mixed Herd Stats
elseif simulationtype == 2
bar(main_figure_plot_axes,1:2,...
    [total_deaths_rule_1 total_deaths_rule_2]) 
    axis(main_figure_plot_axes, [0 3 ...
        0 (max([total_deaths_rule_1 total_deaths_rule_2]) + 5)])
    
%Set Up Axis Labels    
    set(main_figure_plot_axes, ...
        'fontsize',small_font,...
        'xticklabel',({rule_1_string, rule_2_string}),...
        'xtick',[1 2])
    xlabel('Herd Movement Rules','fontsize',medium_font)
    ylabel('Number of Dead Prey','fontsize',medium_font)
end

%If Animation Window Is Open
elseif ui_plot_desired == 2
plot(main_figure_plot_axes,plot_info_storage)
axis(main_figure_plot_axes,[0 360 ...
       0 360])
set(main_figure_plot_axes, ...      
        'xticklabelmode','auto',...
        'xtick',(0:50:360),...
        'yticklabelmode','auto',...
        'ytick',(0:50:360),...
        'fontsize',small_font);
    xlabel(' ','fontsize',medium_font)
    ylabel(' ','fontsize',medium_font)   
end
%------------------------------------------------------------------------  
%-----------------------Creates Unique Identifiers-----------------------
%------------------------------------------------------------------------
%Creates String with current date
date_run_was_started = strcat(datestr(now,'mm-dd-yy'),'_Date_',...
                              datestr(now,'HH-MM-SS'),'_Time');
                                    
%-------------------------------------------------------------------
%----------------------------Data Saving----------------------------
%-------------------------------------------------------------------
%The Name of The Save File For The Simulation Is Generated here if Data
%Saving Is Desired Before Being Placed On The UI

%Change Path To Current Savepath If This Isn't The First Run With Saving
    cd(savepath)
if savetotxtfile == 2
    if filename_entered == 1 || strcmp(filename,' --- ') == 1
%Creates Save File Name From Info Provided In The UI
if simulationtype == 1
    if herdmovementrule == 1
        name_of_save_file = strcat('DOD','_LCH');
    elseif herdmovementrule == 2
        name_of_save_file = strcat('DOD','_LCH_W_Noise');
    elseif herdmovementrule == 3
        name_of_save_file = strcat('DOD','_Voronoi');
    elseif herdmovementrule == 4
        name_of_save_file = strcat('DOD','_Voronoi_W_Noise');    
    end
elseif simulationtype == 2
    if herdmovementrule == 1
        rule_1 = strcat('Mixed_Herd','_LCH');
    elseif herdmovementrule == 2
        rule_1 = strcat('Mixed_Herd','_LCH_W_Noise');
    elseif herdmovementrule == 3
        rule_1 = strcat('Mixed_Herd','_Voronoi');
    elseif herdmovementrule == 4
        rule_1 = strcat('Mixed_Herd','_Voronoi_W_Noise');    
    end
    if herdmovementrule2 == 5
        name_of_save_file = strcat(rule_1,'_LCH');
    elseif herdmovementrule2 == 6
        name_of_save_file = strcat(rule_1,'_LCH_W_Noise');
    elseif herdmovementrule2 == 7
        name_of_save_file = strcat(rule_1,'_Voronoi');
    elseif herdmovementrule2 == 8
        name_of_save_file = strcat(rule_1,'_Voronoi_W_Noise');    
    end
end
filename = strcat(name_of_save_file,'_',date_run_was_started); 
    end
if savetotxtfile == 2
    [filename,savepath] = uiputfile('*.*','Save File Name',filename);
%Checks If File Name Was Entered
if savepath == 0
    savepath = pwd;
    stopsimulation = 1;
    runinprogress = 1;
    simulation_reset
return
end
%Updates Output On UI
set(btn65b,'string',filename)
end
elseif savetotxtfile == 1
set(btn65b,'string','Data Saving Is Not Enabled For This Run')    
end

%Resets Save File Entered Tracking Variable To 1
filename_entered = 1;

%---------------------------------------------------------------------  
%-------------------------Calculate Herd Size-------------------------
%---------------------------------------------------------------------

%--Calculates Herd size By Movement Rule (1 = First, 2 = Second)
if simulationtype == 1
 
    %Set Second Movement Rule To Equal Zero Becuase There Are No Herd
    %Memebrs Following The Second Movement Rule
    herdmovementrule_2 = 0;
    
    %Calculate The Total Number Of Herd Members
    numberofprey = herdmovementrule_1 + herdmovementrule_2;
elseif simulationtype == 2
%For A Mixed Herd Test Add The Number Of Animals Following Each Movement
%Rule
numberofprey = herdmovementrule_1 + herdmovementrule_2;
    
end

%---------------------------------------------------------------------  
%-------------------------Setup Herd variable-------------------------
%---------------------------------------------------------------------
herdmemberinformation = 0;
%Sets up herdmemberinfo variable for use in code
%----Sets up X,Y positon Values as colmuns 1,2 respectivly
herdmemberinformation((1:numberofprey),1) = 0;
herdmemberinformation((1:numberofprey),2) = 0;

%----Sets Up Max Velocity, X Velocity, Y velocity Vectors as Colums 3,4,5
%respectivly (MAX V set at 1 for now may change in later code if
%implemented, currently a placeholder column)

herdmemberinformation((1:numberofprey),3) = 0;
herdmemberinformation((1:numberofprey),4) = 0;
herdmemberinformation((1:numberofprey),5) = 0;

%----Sets Up Max acceleration, X acceleration, Y acceleration vectors as
%columns 6,7,8 respectivly (Max Acceleeration set at 1 for now may change
%if implemented in later code iterations)

herdmemberinformation((1:numberofprey),6) = 0;
herdmemberinformation((1:numberofprey),7) = 0;
herdmemberinformation((1:numberofprey),8) = 0;

%--Sets Which Movement Rule Herd Members Will Foll Based on Which Animal #
%They Are and What Simulation Type Is Being Done
if simulationtype == 1
 
    %If Not A Mixed Herd Test All Animals Follow The Same Movement Rule
    herdmemberinformation(:,9) = herdmovementrule;

elseif simulationtype == 2
    %For A Mixed Herd Test Set The Movement Rule By Number Of Animals
    %Following It In Order Of Which Animal Is Following THe Movement Rule
    herdmemberinformation(1:herdmovementrule_1,9 )= herdmovementrule;
    herdmemberinformation((herdmovementrule_1+1:numberofprey),9) = ...
                                                      herdmovementrule2;
    
end

%Begins Run
    for runs = 1:numberofruns

%--------------------------------------------------------  
%----------------------Sets up Herd----------------------
%--------------------------------------------------------
if usestandardherd == 1

%--Finds Herds X and Y Values for Locations on Grid

%Finds X and YAxis Locations Seperatly. Combine Each to Get Positons of
%Herd Members
for s = 1:2
    for i = 1:numberofprey
        if s == 1
            herdmemberinformation(i,s) = ((herdspawnarea_xaxis*rand));
        elseif s == 2
            herdmemberinformation(i,s) = ((herdspawnarea_yaxis*rand));
        end
    end
end

%--Checks Distance between Herd Members Respawns Them i One is Too Close to
%Another
for s = 1:numberofprey
    for i = 1:numberofprey
            distances(i,s)= sqrt(abs(((herdmemberinformation(s,1)...
                                  -herdmemberinformation(i,1))^2)...
                                    +((herdmemberinformation(s,2)...
                                -herdmemberinformation(i,2))^2)));
        while distances(i,s) <= minimalanimaldistance && i ~= s
            herdmemberinformation(s,1) = ((herdspawnarea_xaxis*rand));
            herdmemberinformation(s,2) = ((herdspawnarea_xaxis*rand));
            for r = 1:numberofprey
            distances(i,s)= sqrt(abs(((herdmemberinformation(s,1)...
                                  -herdmemberinformation(r,1))^2)...
                                    +((herdmemberinformation(s,2)...
                                -herdmemberinformation(r,2))^2)));
            end
        end
   end
end

elseif usestandardherd == 2

%---------------------------------------------------------
%------------------Creates Standard Herd------------------
%---------------------------------------------------------

constantherdmemberinformation = [-50.3470,146.8428; 149.2114,46.6622;...
    -152.9660,167.2541; -147.5458,97.6847; 12.3967,236.6049;...
    131.7660,160.8365; -114.8865,229.8551; 55.7856,238.5505;...
    -96.5448,267.5216;   60.0987,131.8855;  32.1355,146.5991;...
    166.3571,244.6992;    -76.9767,6.7606;-106.4071,239.8916;...
    56.7628,328.7223;    170.7335,90.4637;-104.3170,218.5158;...
    51.5717,330.1316;    41.3754,296.6168;   87.4519,92.6229;...
    36.9575,154.2324;  -110.2528,193.7609;   9.5033,245.8795;...
    -177.8205  182.9158; 178.0292  287.7225; -169.6232  238.3084;...
    -50.6141   86.4275; -77.5890  247.9092; -166.6261  236.5349;...
    -25.6661   96.6841; 62.3565  356.6025; 174.8294  337.4013;...
    164.0012  167.1142; -74.6497   86.3298; 39.4424  288.8827;...
    154.9357  153.7430; 45.2749  198.6372; -155.4767  214.7370;...
    -150.0869  312.5358; 86.8767  132.0060; 73.2729  300.8620;...
    142.4002  222.7500; 20.4863  260.1497; 79.9638  222.9819;...
    -168.7046   27.4709; -38.6822  345.4892; -50.6832   59.8881;...
    137.3259  248.1472;70.9059   54.2630;161.4914  146.7664;...
    102.5687  285.4708;-93.8649  260.4999;-100.7188   96.5150;...
    44.8774  230.7199;178.8475  210.0050;-66.3250  185.2218;...
    -114.2299   65.5213;-63.9012  148.5853;47.3440  180.9035;...
    -152.6957  229.0725;-42.4774  320.1076;-15.0432   89.5796;...
    -172.9043   25.5253;-73.1329   71.8360;116.9449  132.7816;...
    -81.4073  318.2733;99.0895  180.2505;58.4446  320.8363;...
    3.0641  352.4479;74.9473   59.5362;27.8741  336.1276;...
    154.6285  175.7168;-40.0619   82.6351;-4.8447   21.8213;...
    1.4894   71.1733;-2.5197  181.8848;...
    -169.6652  231.4972;-77.1550  328.7608;110.8759  234.0271;...
    159.8988  115.6024;-118.8796  267.5431;87.1169   68.9328;...
    162.8482  114.8285;-93.0272  245.8048;87.8642  341.7756;...
    23.4183  253.9770;-18.6839  256.6367;-176.8779  282.2935;...
    -13.9674  212.4435;100.3235  143.2586;20.8624  255.6950;...
    -163.9607  293.6523;37.3364   50.4531;147.5754   82.9517;...
    135.7396  355.0736;-118.2221   45.6650;-85.6946  118.1871;...
    -66.0566  236.7233;-74.0301  206.1839;114.9204  175.1820];
for i = 1:numberofprey
    herdmemberinformation(i,1) = constantherdmemberinformation(i,1)+180;
    herdmemberinformation(i,2) = constantherdmemberinformation(i,2);
end
end
%---------------------------------------------------------
%---------------------------------------------------------
%-----------------------Basic Setup-----------------------
%---------------------------------------------------------
%---------------------------------------------------------
%Carries out a variety of task to set up variables for use in the
%simulaition(s) based on settings selected in the UI.

%--------------------------------------------------------
%------------Sets up Basic Plot Area Perameters----------
%--------------------------------------------------------
%Size of Prey and Predator on Plot
preysize = 5;
predatorsize = 25;

%Barriers of Graph in All Four Directions
leftbarrier = -truncationdistance/2;
rightbarrier = herdspawnarea_xaxis + truncationdistance/2;
bottombarrier = -truncationdistance/2;
topbarrier = herdspawnarea_yaxis + truncationdistance/2;

%Length of Each Axis
x_axislength = herdspawnarea_xaxis + 2 * (truncationdistance/2);
y_axislength = herdspawnarea_yaxis + 2 * truncationdistance;

%Sets Barrier Increments For Edge of Graph Calculation
barrierincrements = 1;

%-------------------------------------------------------------
%--Sets up Global Run Variables to Be used Suring Simulation--
%-------------------------------------------------------------
%Keeps Track of Run Time
runtimecounter = 0;

%Determines if a Run Has Ended
endphase = 0;

%----------------------------------------------------------
%-------------------Predator Information-------------------
%----------------------------------------------------------
%Sets up Predatorinfo variable for use in code

%----Sets up X,Y positon Values as colmuns 1,2 respectivly
predatorinfo((1:numberofpredators),1) = 0;
predatorinfo((1:numberofpredators),2) = 0;

%----Sets Up Max Velocity, X Velocity, Y velocity Vectors as Colums 3,4,5
%respectivly (MAX V set at 1 for now may change in later code if
%implemented, currently a placeholder column)

predatorinfo((1:numberofpredators),3) = 0;
predatorinfo((1:numberofpredators),4) = 0;
predatorinfo((1:numberofpredators),5) = 0;

%----Sets Up Max acceleration, X acceleration, Y acceleration vectors as
%columns 6,7,8 respectivly (Max Acceleeration set at 1 for now may change
%if implemented in later code iterations)

predatorinfo((1:numberofpredators),6) = 0;
predatorinfo((1:numberofpredators),7) = 0;
predatorinfo((1:numberofpredators),8) = 0;

%Sets up max number of kills and kills needed as columns 9,10 respectivly
predatorinfo((1:numberofpredators),09) = 0;
predatorinfo((1:numberofpredators),10) = 0;

%Resets predator spawn tracking variable between runs
predator_spawned = 0;
%---------------------------------------------------
%------------------Runs Simulation------------------
%---------------------------------------------------


%Runs Simulation
run_simulation
%Checks If Run Has been Terminated If So Ends Loop
if stopsimulation == 2
    stopsimulation = 1;
    runinprogress = 1;
return
end
    end
%---------------------------------------------------------------
%---------------------------------------------------------------
%------------------Runs Code Based On Settings------------------
%---------------------------------------------------------------
%---------------------------------------------------------------

%This Fucntion Executes The Code Using The Settings Determined By the UI.
%It Starts By Reseting The Velocity And Acceleration Vectors Of The Herd To
%Zero before Executing The Rest Of The Code.

    function run_simulation(~,~)
  

    initial_voronoi_check = 1;
    endofrun = 1;
%-----------------------------------------------------------------
%-------------For Loop That Excecutes Code Until Done-------------
%-----------------------------------------------------------------
%This Loop Runs Until P = #Of Timesteps FOr SImplicity, The Code Will
%Create Movement Vectors For The Normal Herd No Matte What And The Mutant
%Herd Only When Selected

%Initializes p Used To Control While Loop Run Times Based On Number Of
%Timesteps
p = 0;

%Sets Displayed Timesteps To 0
timesteps_display = 0;

while p ~= timesteps

%Checks If Stopbutton Has been Pressed And If So Stops Current Simulation
%Runs And Resets Variables As Needed
drawnow
if stopsimulation == 2
simulation_reset
return
end

%Increases displayed timesteps count
timesteps_display = timesteps_display + 1;

p = p + 1;
%Sets Run In Progress Tracking Variable to 2 Indicating Theat A Run Is
%Underway
runinprogress = 2;


 %--Finds Voronoi Tesselation And Area 
 voronoi_tesselation

 
%------------------------------------------------------------------
%--------------Creates  Herd Memeber Movement Vectors--------------   
%------------------------------------------------------------------ 
%This Section Creates The Movement Vectors For Each Animal In The Herd
%Based on The Movement Rule That They Follow Only Running A Rule If An
%Animal in The Herd Follows The Specific Rule

%Checks If An Animal Follows The LCH Movement Rule Regardless of Noise If
%There Is One Animal Following This Rule The LCH_Movement Function Will Be
%Executed
if (herdmovementrule == 1 || herdmovementrule == 2) || ...
  ((herdmovementrule2 == 5 || herdmovementrule2 == 6) && ...
    simulationtype == 2)
    LCH_movement
end
%Checks If An Animal Follows The Voronoi Movement Rule Regardless of Noise
%If There Is One Animal Following This Rule The Voronoi_Movement Function
%Will Be Executed
if (herdmovementrule == 3 || herdmovementrule == 4) || ...
  ((herdmovementrule2 == 7 || herdmovementrule2 == 8) && ...
    simulationtype == 2)
    Voronoi_movement
end
%Excecutes Noise Function If Noise Is Desired 
if (herdmovementrule == 2 || herdmovementrule == 4) || ...
  ((herdmovementrule2 == 6 || herdmovementrule2 == 8) && ...
    simulationtype == 2)
    Noise_movement
end

%Moves Herd
movement_implementation

%------------------------------------------------------------------------
%---------------------Predator spawning And movement---------------------   
%------------------------------------------------------------------------
if simulationtype == 2
if p == timesteps || predator_spawned == 1
 
%Predator Spawns if not already spawned
if predator_spawned == 0
predator_spawn
%Reset death counters
first_herd_deaths = 0;
second_herd_deaths = 0;
end
%Creates Movement Vectors for Predators
predator_movement_vectors
%Moves Predators
predator_movement
%Checks ofr dead prey removes dead animals, victorious predators, tracks
%total dead
predator_kills
totalkills = first_herd_deaths + second_herd_deaths;
% Resets P Until Enough Prey Have Died
if totalkills >= killstoendhunt
    p = timesteps;
else
    p = 0;
end
end
end


%Plots Herd And/Or Predator(s) If Desired
plot_data

end
%Exits Funtion If Stop button Is Pressed
if stopsimulation == 2
simulation_reset
return
end

%Sets End Of Run Tracking variable To = 2 Indicating The End Of 1 Run
endofrun = 2;

%Calcuulates Final Voronoi Teselation
voronoi_tesselation

%Calculates Total Deaths By Rule
total_deaths_rule_1 = total_deaths_rule_1 + first_herd_deaths;
total_deaths_rule_2 = total_deaths_rule_2 + second_herd_deaths;

%Plots Final Data Output From Either The Current Run Or All Runs
plot_data

%Variable use to determine when every 25 runs are done
runtracker = (25:25:10000);
%Saves Data From Run every 25 runs or at end of all runs
if savetotxtfile == 2 && (runs == numberofruns || mod(runs,25) == 0)
    
   run_data_saving
   
end
if runs == numberofruns
%Shows Run Time
    toc
%Sets Run In Progress Tracking Variable to 1 Indicating Theat A Run Is
%Not Currently Being Done
runinprogress = 1;
simulation_reset
end
%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-----------------------Voronoi Tesselation-----------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------

%This Function is Used to Create the Voronoi Tesselation Plot of The
%Animals Positions

    function voronoi_tesselation(~,~)
        
%------------------------------------------------------------------
%-----------------Finds Points Closest To The Edge-----------------
%------------------------------------------------------------------

%Because The Voronoi and Voronoin Fucntions Defualt to an Unbound Voronoi
%Tesselation We Fisrt Need To Define the Boundries of The Herd

%Declares Matrixes For Storing Points Closest to Edge For Each Edge of The
%Tesselation

bottomedgepoints = [];
rightedgepoints = [];
topedgepoints = [];
leftedgepoints = [];

%-----------------------------------------------------------
%--------------Finds Points near Boundry Edges--------------
%-----------------------------------------------------------

%Each Edge Will Be Computed Seperatly Starting with the Bottom

%--Calculates Edge Points For Bottom of Boundry Area

y_edgepoint = bottombarrier;
x_edgepoint = leftbarrier;
distancetoedgepoint = 0;
closestbottompoints = 0;

for s = 1:x_axislength
for i = 1:numberofprey
    distancetoedgepoint(i) =                                ...
      sqrt(((x_edgepoint - herdmemberinformation(i,1))^2) + ...
           ((y_edgepoint - herdmemberinformation(i,2))^2));
    
end

    closestbottompoints(s) = find(distancetoedgepoint == ...
                              min(distancetoedgepoint));
    x_edgepoint = x_edgepoint + barrierincrements;
    
end
bottomedgepoints = unique(closestbottompoints);    

%--Calculates Edge Points For Right Side of Boundry Area

y_edgepoint = bottombarrier;
x_edgepoint = rightbarrier;
distancetoedgepoint = 0;
closestrightpoints = 0;

for s = 1:y_axislength
for i = 1:numberofprey
    distancetoedgepoint(i) =                                ...
      sqrt(((x_edgepoint - herdmemberinformation(i,1))^2) + ...
           ((y_edgepoint - herdmemberinformation(i,2))^2));
    
end
    closestrightpoints(s) = find(distancetoedgepoint == ...
                              min(distancetoedgepoint));
    y_edgepoint = y_edgepoint + barrierincrements;
    
end
rightedgepoints = unique(closestrightpoints);

%--Calculates Edge Points For Top of Boundry Area

y_edgepoint = topbarrier;
x_edgepoint = leftbarrier;
distancetoedgepoint = 0;
closesttoppoints = 0;

for s = 1:x_axislength
for i = 1:numberofprey
    distancetoedgepoint(i) =                                ...
      sqrt(((x_edgepoint - herdmemberinformation(i,1))^2) + ...
           ((y_edgepoint - herdmemberinformation(i,2))^2));
    
end
    closesttoppoints(s) = find(distancetoedgepoint == ...
                              min(distancetoedgepoint));
    x_edgepoint = x_edgepoint + barrierincrements;
    
end
topedgepoints = unique(closesttoppoints);  

%--Calculates Edge Points For left Side of Boundry Area

y_edgepoint = bottombarrier;
x_edgepoint = leftbarrier;
distancetoedgepoint = 0;
closestleftpoints = 0;

for s = 1:x_axislength
for i = 1:numberofprey
    distancetoedgepoint(i) =                                ...
      sqrt(((x_edgepoint - herdmemberinformation(i,1))^2) + ...
           ((y_edgepoint - herdmemberinformation(i,2))^2));
    
end
    closestleftpoints(s) = find(distancetoedgepoint == ...
                              min(distancetoedgepoint));
    y_edgepoint = y_edgepoint + barrierincrements;
    
end
leftedgepoints = unique(closestleftpoints);

%-----------------------------------------------------------
%--------------------Finds Mirror Points--------------------
%-----------------------------------------------------------

%For Each Boundry Point a Duplicate is Created On The Opposite Side of The
%Line it is a Boundry Point on

%--Mirror Points For Bottom Edge
mirrorpoints = 0;
n=0;
s=0;
for i = 1:length(bottomedgepoints)
    mirrorpoints(i,1) = herdmemberinformation(bottomedgepoints(i),1);
    mirrorpoints(i,2) = 2 * bottombarrier - ...
        herdmemberinformation(bottomedgepoints(i),2);
    n = n + 1;
   
end

%--Mirror Points For Top Edge

for i = 1:length(topedgepoints)
   s = i + n;
   mirrorpoints(s,1) = herdmemberinformation(topedgepoints(i),1);
   mirrorpoints(s,2) = 2 * topbarrier - ...
        herdmemberinformation(topedgepoints(i),2);
  

end
 n = n + i;
%--Mirror Points For Right Edge

for i = 1:length(rightedgepoints)
    s = i + n;
    mirrorpoints(s,1) = 2 * rightbarrier - ...
        herdmemberinformation(rightedgepoints(i),1);
    mirrorpoints(s,2) = herdmemberinformation(rightedgepoints(i),2);
  
end
 n = n + i;
%--Mirror Points For Left Edge

for i = 1:length(leftedgepoints)
    s = i + n;
    mirrorpoints(s,1) = 2 * leftbarrier - ...
        herdmemberinformation(leftedgepoints(i),1);
    mirrorpoints(s,2) = herdmemberinformation(leftedgepoints(i),2);
 
end




%----------------------------------------------------------------------
%------------------Finds Area Of Voronoi Tesselation-------------------
%----------------------------------------------------------------------

%--Find Area of Voronoi Tesselation
    areadata = 0;
    for i = 1:numberofprey
        areadata(i,1) = herdmemberinformation(i,1);
        areadata(i,2) = herdmemberinformation(i,2);
    end
    
    for i = 1:length(mirrorpoints)
        areadata((i+numberofprey),1) = mirrorpoints(i,1);
        areadata((i+numberofprey),2) = mirrorpoints(i,2);
    end

   [v , c] = voronoin(areadata);

    for i = 1:size(c,1)
        val = c{i}';
        voronoi_area(i,1) = polyarea( v(val,1), v(val,2) );
    end    

%Stores Voronoi Area For The First And LAst Timestep For Later Proccessing
if  initial_voronoi_check == 1
    
    initial_voronoi_area = voronoi_area(1:numberofprey,1);
  
    initial_voronoi_check = 2;
    
elseif p == timesteps
    
    final_voronoi_area = voronoi_area(1:numberofprey,1);
end
    end

%-----------------------------------------------------------------
%-----------------------------------------------------------------
%-------------------------Movement Models-------------------------
%-----------------------------------------------------------------
%-----------------------------------------------------------------

%This is A Large Section Containing The Code Used To Allow Both Herd And
%Predator Movement Modeld Its Own Function, Along With The Code That
%Implements The Movement Itself

%------------------------------------------------------------------
%------------------------LCH Movement Model------------------------
%------------------------------------------------------------------

function LCH_movement(~,~)





%--First Find Distances Between Herd Members
herdmemberdistances_x = bsxfun(@minus,herdmemberinformation(:,1), ...
                            transpose(herdmemberinformation(:,1)));
herdmemberdistances_y = bsxfun(@minus,herdmemberinformation(:,2), ...
                            transpose(herdmemberinformation(:,2)));
LCH_distances = sqrt(abs(herdmemberdistances_x.^2 + ...
                               herdmemberdistances_y.^2));

%--Implements LCH Movement
for i = 1:numberofprey
    
%Checks If Current Animal Follows LCH Movement Model If It Does Then an
%LCH Movement Vector Is Calculated   
if herdmemberinformation(i,9) == 1 || herdmemberinformation(i,9) == 2 ||...
   herdmemberinformation(i,9) == 5 || herdmemberinformation(i,9) == 6
  
    
    for s = 1:numberofprey


%Finds Acceleration And Uses Acceleration To Create New Velocity 
        if herdmemberinformation(i,1) ~= herdmemberinformation(s,1)
           herdmemberinformation(i,4) =  herdmemberinformation(i,4) + ...
         (((herdmemberinformation(s,1) - herdmemberinformation(i,1))/ ...
         (LCH_distances(i,s)))                                          * ...
         (weightofdistancetofear/(weightofdistancetofear            + ...
          (LCH_distances(i,s) * fear_constant))));
           herdmemberinformation(i,5) =  herdmemberinformation(i,5) + ...
         (((herdmemberinformation(s,2) - herdmemberinformation(i,2))/ ...
         (LCH_distances(i,s)))                                          * ...
         (weightofdistancetofear/(weightofdistancetofear            + ...
          (LCH_distances(i,s) * fear_constant))));

        end
    end       
%--Normalizes Velocity

%First Each Noramalized Vector Is Stored In theTemporary Herd before Being
%Added back To The Main herd.
    
    temporaryherdmemberinformation(i,4) = (herdmemberinformation(i,4) / ...
    (sqrt((herdmemberinformation(i,4)^2)+(herdmemberinformation(i,5)^2))));
    temporaryherdmemberinformation(i,5) = (herdmemberinformation(i,5) / ...
    (sqrt((herdmemberinformation(i,4)^2)+(herdmemberinformation(i,5)^2))));

    herdmemberinformation(i,4) = temporaryherdmemberinformation(i,4);
    herdmemberinformation(i,5) = temporaryherdmemberinformation(i,5);
end       
end   

end
    
%------------------------------------------------------------------
%----------------------Voronoi Movement Model----------------------
%------------------------------------------------------------------

%For This Movement Model Animals Move Towards Their Voronoi Neighbors.
%This Is Determined using The Vertexes Found In The Voroinoi Function
%Needed To Calculate The Voronoi Area. This Movement Model Works In Two
%Parts
%In part 1) The Voronoi Neighbors Of Each Animals Is Determined.
%In Part 2) The Information From part One Is Used To Create And Normalize A
%Movement Vector For Each Animal In The Herd.

    function Voronoi_movement(~,~)
%-------------------------------------------------------------------
%----------------------Finds Voronoi Neighbors----------------------
%-------------------------------------------------------------------

%This part Of The Function Carries Out Three Steps To Find And Catalogue
%Each Herd Member And It's  Voronoi Neighbor.
%Step 1 Unpacks the Vertex Information
%Step 2 Finds The Distances From Each Animal In The Herd To Each Vertex
%Step 3 Finds Herd Members Who Are Equidistant To The Same Vertext And Adds
%Them To A Matrix Of Animals With Voronoi Neighbors.

%First Need To Set Up The matrix That Will Hold The Information On Whether
%Or Not Two Animals In The Herd Are Equidistant To The Same Vertex. This
%Info Will Be Recorded In A Matrix that Is N x N Where N = nuberofprey. A
%One Will Be Placed In The Matrix If Two Animals Are Equidisant From A
%Vertex In Step Three


 neighboringherdmembers = zeros(numberofprey);

%--Step One Unpacking Vertex Information

    voronoivertexes = v(v~=inf);
    voronoivertexes = reshape(voronoivertexes,length(voronoivertexes)/2,2);
    
%--Step Two Finding Distances To Vertices
    
    numberofvertexes_2 = length(voronoivertexes);
    for i = 1:numberofvertexes_2
    for s = 1:numberofprey  
       vertexdistances(s)= round(sqrt(abs(((herdmemberinformation(s,1)...
                                               -voronoivertexes(i,1))^2)...
                                           +((herdmemberinformation(s,2)...
                                          -voronoivertexes(i,2))^2))),8);

%--Step Three Find Herd Members Who Are Equidistant From The Same Vertex
%And Logs It In A Matrix

    equidistantpoints = find(vertexdistances == vertexdistances(s));
    if length(equidistantpoints) >  1
    neighboringherdmembers(equidistantpoints,equidistantpoints) = 1;
    end
    end
    
end


%--------------------------------------------------------------------
%-------------------Finds Voronoi Movement Vectors-------------------
%--------------------------------------------------------------------
%This part of The Code Uses The neighboringherdmembers Matrix To Create A
%Normalized Movement Vector For Each Herd Member.


for i = 1:numberofprey
    
%Checks If Current Animal Follows Voronoi Movement Model If It Does Then an
%Voronoi Movement Vector Is Calculated   
if herdmemberinformation(i,9) == 3 || herdmemberinformation(i,9) == 4 ||...
   herdmemberinformation(i,9) == 7 || herdmemberinformation(i,9) == 8  
    for s = 1:numberofprey
        
%Allows COde To Be Run Only If The Values For i,s Corrospond To Two
%Herdmembers That Are Voronoi Neighbors
        if (neighboringherdmembers(i,s) == 1 && (i ~= s))
            
%Part 1 Find Distances Between Voronoi Neighbor Herd Memebers           
           voronoidistance = sqrt(abs(((herdmemberinformation(i,1)...
                                   -herdmemberinformation(s,1))^2)...
                                     +((herdmemberinformation(i,2)...
                                 -herdmemberinformation(s,2))^2)));
                             
%Part 2 Uses Distance Info To Find An acceleration Vector Between Each Herd
%Member And Herd Member i, Then Adds It To The Previously Calculated
%Velocity Vector
            herdmemberinformation(i,4) = herdmemberinformation(i,4) + ...
          ((herdmemberinformation(s,1) - herdmemberinformation(i,1))/ ...
         (voronoidistance));                 
            herdmemberinformation(i,5) = herdmemberinformation(i,5) + ...                              ...
          ((herdmemberinformation(s,2) - herdmemberinformation(i,2))/ ...
         (voronoidistance));               
        end
    end

%Part 3 Normalize Velocity Vectors    
    temporaryherdmemberinformation(i,4) = (herdmemberinformation(i,4) / ...
    (sqrt((herdmemberinformation(i,4)^2)+(herdmemberinformation(i,5)^2))));
    temporaryherdmemberinformation(i,5) = (herdmemberinformation(i,5) / ...
    (sqrt((herdmemberinformation(i,4)^2)+(herdmemberinformation(i,5)^2))));

    herdmemberinformation(i,4) = temporaryherdmemberinformation(i,4);
    herdmemberinformation(i,5) = temporaryherdmemberinformation(i,5);
    
end
end

end
    
%------------------------------------------------------------------
%-----------------------Noise Movement Model-----------------------
%------------------------------------------------------------------

%Adds Random Noise To Herds Movement

function Noise_movement(~,~)
        
    for i = 1:numberofprey
%Checks If Current Animal Follows Noise Movement Model If It Does Then a
%Noise Movement Vector Is Calculated   
if herdmemberinformation(i,9) == 2 || herdmemberinformation(i,9) == 4||...
   herdmemberinformation(i,9) == 6 || herdmemberinformation(i,9) == 8              
%--Creates Random Number For Movement
    randomnoise = rand;
    herdmemberinformation(i,7) = 0;
    herdmemberinformation(i,8) = 0;
%--Uses Random Number To Create A Random Movement Velocity For Each Herd
    %Member
    
    herdmemberinformation(i,7) = herdmemberinformation(i,4)+...
        noiseweight * (cos(2*pi*randomnoise));
    herdmemberinformation(i,8) = herdmemberinformation(i,5)+...
        noiseweight * (sin(2*pi*randomnoise));
    
%--Add Normalized Velocity To Velocity Vector
    herdmemberinformation(i,4) = herdmemberinformation(i,7)/...
        (sqrt((herdmemberinformation(i,7)^2) +...
               herdmemberinformation(i,8)^2));
    herdmemberinformation(i,5) = herdmemberinformation(i,8)/...
        (sqrt((herdmemberinformation(i,7)^2) +...
               herdmemberinformation(i,8)^2));
           
    end
    end        
end
    




%-------------------------------------------------------------------
%----------------------Movement Implimentation----------------------
%-------------------------------------------------------------------

%Implements Prey Movement

function movement_implementation(~,~)
    
%Normalizes Velocity Vectors
    temporaryherdmemberinformation(:,4) = herdmemberinformation(:,4)./...
        (sqrt((herdmemberinformation(:,4).^2) +...
               herdmemberinformation(:,5).^2));
    temporaryherdmemberinformation(:,5) = herdmemberinformation(:,5)./...
        (sqrt((herdmemberinformation(:,4).^2) +...
               herdmemberinformation(:,5).^2));
  
%Moves Herd And Saves New Position As A temporary Position So that The New
%Position Can Be Checked For Movement Rule Violations.

     temporaryherdmemberinformation(:,1) = herdmemberinformation(:,1) +...
                                  temporaryherdmemberinformation(:,4);
     temporaryherdmemberinformation(:,2) = herdmemberinformation(:,2) +...
                                  temporaryherdmemberinformation(:,5);


%----Checks That Animal Movement Doesn't Violate Minimum Distance----
%For Each Animal A seperate Distance Matrix Is Calculted And Used To
%Determine If An Animal Violates The Minimum Distance It Can Be From Other
%Animals In The Herd, If It Does Violate This Then THe Animal Is Moved Back
for i = 1:numberofprey
    nonixvalues = vertcat(herdmemberinformation((1:(i-1)),1),  ...
          herdmemberinformation(((i+1):numberofprey),1));
    noniyvalues = vertcat(herdmemberinformation((1:(i-1)),2),  ...
          herdmemberinformation(((i+1):numberofprey),2));
    distances = sqrt(abs(((temporaryherdmemberinformation(i,1) - ...
                                            (nonixvalues)).^2) + ...
                         ((temporaryherdmemberinformation(i,2) - ...
                                          (noniyvalues)).^2)));
    if (isempty((find((distances(distances~=0) ...
            < 2*minimalanimaldistance))))==0)
%Moves Animals Back If True

    temporaryherdmemberinformation(i,1) = herdmemberinformation(i,1);
    temporaryherdmemberinformation(i,2) = herdmemberinformation(i,2);

    end
end



%Replaces previous Herd Member Positions With The New Positions After One
%Timestep Of Movement Then Zeroes Each Velocity And Acceleration Vector
       herdmemberinformation(:,1) = temporaryherdmemberinformation(:,1);
       herdmemberinformation(:,2) = temporaryherdmemberinformation(:,2);
       herdmemberinformation(:,4) = 0;
       herdmemberinformation(:,5) = 0;
       herdmemberinformation(:,7) = 0;
       herdmemberinformation(:,8) = 0;
    
end
%----------------------------------------------------------------
%----------------------------------------------------------------
%---------------------Predator Functionality---------------------        
%----------------------------------------------------------------        
%----------------------------------------------------------------
%Contained here are the cod functions that didctate how a predator(s) will
%spawn and behave first is the function that spawns the predator in a
%circle around the heard then we have the second funtion that creates a
%movement vector for the predator, next is the function which will move the
%predator and last is the function that actually allows a predator to kill
%the prey.

%-----------------------------------------------------------------
%-------------------------Spawns Predator-------------------------  
%-----------------------------------------------------------------
%This function spawns a(n) predator(s) distributed randomly on a circle
%radius x centered on the center of the spawn area after a specified
%timestep

function predator_spawn(~,~)
      
    for i = 1:numberofpredators
%--Creates Random Number For Spawning
random_spawn_position_number = rand;           
      
%Uses Random Number To Spawn Predator Set Distance From Center Of Herd Area
predatorinfo(i,1) = herdspawnarea_xaxis/2 + ...
                    predatorspawndistance * ...
                    cos(2*pi*random_spawn_position_number);
predatorinfo(i,2) = herdspawnarea_yaxis/2 + ...
                    predatorspawndistance * ...
                    sin(2*pi*random_spawn_position_number);

    end 
    
predator_spawned = 1;
end

%---------------------------------------------------------------------
%----------------------Predator Movement Vectors----------------------
%---------------------------------------------------------------------
%Creates A movement vector for the predator(s) towards the prey nearest to
%them

%Storage variables for distances, closest prey
predator_distances = [];
closest_prey = [];
function predator_movement_vectors(~,~)
    
for i = 1:numberofpredators  
    for s = 1:numberofprey
%--First Find Distances from Herd Members for one predator

predator_distances(s) = sqrt(abs(((herdmemberinformation(s,1)...
                                  -predatorinfo(i,1))^2)...
                                +((herdmemberinformation(s,2)...
                                  -predatorinfo(i,2))^2)));
    end   
    
%Finds Closest prey
closest_prey(i) = find(predator_distances == min(predator_distances));

%Next For Current Predator Creates an acceleration vector towards nearist
%prey
predatorinfo(i,7) = ((herdmemberinformation(closest_prey(i),1) - ...
                      predatorinfo(i,1)) / ...
                      predator_distances(closest_prey(i))); 
predatorinfo(i,8) = ((herdmemberinformation(closest_prey(i),2) - ...
                      predatorinfo(i,2)) / ...
                      predator_distances(closest_prey(i)));
%Normalizes Predator acceleration vector as its velocity vectors
predatorinfo(i,4) = predatorinfo(i,7) / ...
    (sqrt((predatorinfo(i,7)^2) + (predatorinfo(i,8)^2)));
predatorinfo(i,5) = predatorinfo(i,8) / ...
    (sqrt((predatorinfo(i,7)^2) + (predatorinfo(i,8)^2)));
end
end

%----------------------------------------------------------------------
%--------------------------Predator Movement --------------------------
%----------------------------------------------------------------------
%Moves Predator towards herd based on calculated movement vectors

function predator_movement(~,~)

    %Normalizes Velocity Again
    for i = 1:numberofpredators
predatorinfo(i,4) = predatorinfo(i,7) / ...
    (sqrt((predatorinfo(i,7)^2) + (predatorinfo(i,8)^2)));
predatorinfo(i,5) = predatorinfo(i,8) / ...
    (sqrt((predatorinfo(i,7)^2) + (predatorinfo(i,8)^2)));
    end

    %Moves Predator
    predatorinfo(:,1) = predatorinfo(:,1) + predatorinfo(:,4);
    predatorinfo(:,2) = predatorinfo(:,2) + predatorinfo(:,5);
    
    %Zeroes other vectors
    predatorinfo(:,4) = 0;
    predatorinfo(:,5) = 0;
    predatorinfo(:,7) = 0;
    predatorinfo(:,8) = 0;
end         
%----------------------------------------------------------------------
%----------------------------Predator Kills----------------------------
%----------------------------------------------------------------------
%handels predator prey interactions by checking if predator is within 1
%distance of a prey if it is then that prey is dead and its death is
%recorded in a tracking variable by type of prey normal or mutant
function predator_kills
%temproary variable for tracking deaths by predatoras each round
killed_animals = 0;
killed_animals = [];
animal_was_killed = 0;
%Checks distance from predator to prey
for i = 1:numberofpredators  
for s = 1:numberofprey
%--First Find Distances from Herd Members for one predator

predator_distances(s) = sqrt(abs(((herdmemberinformation(s,1)...
                                  -predatorinfo(i,1))^2)...
                                +((herdmemberinformation(s,2)...
                                  -predatorinfo(i,2))^2)));
    end
%If there is a distance less then 1 kills predator and records death i
%animal is not already dead by another predator
if min(predator_distances) < 1
dead_prey = find(predator_distances < 1);    
killed_animals = [killed_animals;dead_prey];
killed_animals = unique(killed_animals);
animal_was_killed = 1;
end
end

%sorts dead animals by movement type
if animal_was_killed == 1
for i = 1:length(killed_animals)
if herdmemberinformation(killed_animals(i),9) == herdmovementrule
    first_herd_deaths = first_herd_deaths + 1;
elseif herdmemberinformation(killed_animals(i),9) == herdmovementrule2
    second_herd_deaths = second_herd_deaths + 1;
end
end
end
end

%-------------------------------------------------------------------
%-------------------------------------------------------------------    
%------------Plots Herd And Predators For Each Time Loop------------   
%-------------------------------------------------------------------
%-------------------------------------------------------------------
        function plot_data(~,~)
%This Function Will Plot The Herd of Animals For A DOD Reduction Test Or
%The Animals By Movement Rule For Mixed Herd Testing And The Predator When
%It Spawns

%Makes SUre Sindow Hasn't Been Closed If It Has Closes Down Code Run
if fh1 ~= gcf
end_code_now
return 
end
%------------------------------------------------------------------
%------------------------------------------------------------------
%---------------------Data From Run Processing---------------------
%------------------------------------------------------------------    
%------------------------------------------------------------------
%Processes Data From Each Run To Later Be Included In The Printout Of Run
%Data

%-------------------------------------------------------------------         
%---------------------Displays Current Timestep---------------------
%-------------------------------------------------------------------
%Outputs Current Timestep To UI If Its A Mixed Herd Run after The Predator
%Spawns It Displays The Total Number Of Timeteps Instead
if simulationtype == 1
set(btn63b, 'String', num2str(p));
elseif simulationtype == 2 && predator_spawned == 0
set(btn63b, 'String', num2str(p));    
elseif simulationtype == 2 && predator_spawned == 1
set(btn63b, 'String', strjoin({num2str(timesteps),' + ',...
                      num2str(timesteps_display - timesteps)}));
end
%Data From End Of Run Processing
if endofrun == 2
%------------------------------------------------------------------         
%-------------Calculates Change In DoD For Each Animal-------------
%------------------------------------------------------------------
if simulationtype == 1
numberofherdmemberswithchanging_dod = 0;
for i = 1:numberofprey
    if final_voronoi_area(i) < initial_voronoi_area(i)
        numberofherdmemberswithchanging_dod = ...
            numberofherdmemberswithchanging_dod + 1;
    end
    
end

percentofherdmemberswithdecreasing_dod(runs) = ...
    100 * (numberofherdmemberswithchanging_dod / numberofprey);
%Change in DOD For bar graph
sorted_percentofherdmemberswithdecreasing_dod(...
round(100 * (numberofherdmemberswithchanging_dod / numberofprey))) = ...
sorted_percentofherdmemberswithdecreasing_dod(...
round(100 * (numberofherdmemberswithchanging_dod / numberofprey))) + 1;

mean_percentofherdmemberswithdecreasing_dod = ...
    mean(percentofherdmemberswithdecreasing_dod(:));
std_percentofherdmemberswithdecreasing_dod = ...
    std(percentofherdmemberswithdecreasing_dod(:));

end
%---------------------------------------------------------------------
%---------------------------------------------------------------------         
%-----------------Sorts And Displays Run Info In UI-------------------
%---------------------------------------------------------------------
%---------------------------------------------------------------------
%This Section Governs Data Outpus For The Entire Run To The Main UI

%------------------------------------------------------------------
%-------------------Outputs Results For DOD Runs-------------------
%------------------------------------------------------------------
%Sorts Percent DOD decrease into sorted variable and plots on UI If DOD is
%selected as runtype alon with other values

if simulationtype == 1 
%Current Average % Improvemnt In DOD For Simualtion
set(btn61, 'String', num2str(round( ...
    mean_percentofherdmemberswithdecreasing_dod,2)));

%Current Standard Deviation
set(btn62b, 'String', num2str(round(...
    std_percentofherdmemberswithdecreasing_dod,2)));
if ui_plot_desired ~= 2
%Plots Bar Graph
bar(main_figure_plot_axes,1:100,...
    sorted_percentofherdmemberswithdecreasing_dod) 
%Find First Non Zero Value And Last Non Zero Value For The Axis Of The Bar
%Plot
firstnon_0 = find(sorted_percentofherdmemberswithdecreasing_dod,1,'first');
lastnon_0 = find(sorted_percentofherdmemberswithdecreasing_dod,1,'last');

%Sets Up Tick marks
set(main_figure_plot_axes, ...      
        'xticklabelmode','auto',...
        'xtick',(firstnon_0 - 5):5:(lastnon_0 + 5),...
        'fontsize',small_font);
    
%Labels Axis
xlabel('Percent of Herd Improving DOD','fontsize',medium_font)
ylabel('Cumulative Statistics','fontsize',medium_font)

axis(main_figure_plot_axes, ...
[(firstnon_0 - 5) (lastnon_0 + 5) ...
 0 (max(sorted_percentofherdmemberswithdecreasing_dod) + 5)]) 

end
end

%-------------------------------------------------------------------------
%-------------------Outputs Results For Mixed Herd Runs-------------------
%-------------------------------------------------------------------------
%Outputs Data To The Ui Based On The Results Of The Mixed Heard Runs in The
%Number Of Times A Herd member Following Te First Or Second Movemen Rule
%Was Killed In Their Respective Columns

if simulationtype == 2
%Output Current Death Totals
   set(btn61, 'String', num2str(total_deaths_rule_1)); 
   set(btn62b, 'String', num2str(total_deaths_rule_2)); 
   if ui_plot_desired ~= 2
%Plot Data
   bar(main_figure_plot_axes,1:2,...
    [total_deaths_rule_1 total_deaths_rule_2])  
   axis(main_figure_plot_axes, [0 3 ....
        0 (max([total_deaths_rule_1 total_deaths_rule_2]) + 5)])
%Labels Axis
   set(main_figure_plot_axes, ...
        'fontsize',small_font,...
        'xticklabel',({rule_1_string, rule_2_string}))
   xlabel('Herd Movement Rules','fontsize',medium_font)
   ylabel('Number of Dead Prey','fontsize',medium_font)
   end
end

%Current Run
set(btn64b, 'String', num2str(runs));
end

%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
%------------------------Outputs Animation To Ui------------------------
%-----------------------------------------------------------------------
%-----------------------------------------------------------------------
%Plots The Current Animation On UI If Desired
if ui_plot_desired == 2
%------------------------------------------------------------------
%--------------------Plots Voronoi Tesselation---------------------
%------------------------------------------------------------------
%Plots The Voronoi Tesselation For The Herd Using Information Calculated In
%The Voronoi Function
%--Plots Voronoi Tesselation (Domain of Danger)
if  simulationtype == 1

    voronoi(main_figure_plot_axes,...
    [transpose(herdmemberinformation(...
    (herdmemberinformation(:,1)~=0),1)),...
    transpose(mirrorpoints(:,1))],...
    [transpose(herdmemberinformation(...
    (herdmemberinformation(:,2)~=0),2)),...
    transpose(mirrorpoints(:,2))]);


    axis(main_figure_plot_axes,[0 360 ...
       0 360])

end
%-------------------------------------------------------------------
%-------------------------Plots Mixed Herd--------------------------
%-------------------------------------------------------------------
%Plots Animals With A Different Color And Marker Depending on if They
%Follow The Normal or Mutant movement Rule.
if simulationtype == 2 && predator_spawned ~= 1


plot(main_figure_plot_axes,herdmemberinformation(1:herdmovementrule_1,1)...
      ,herdmemberinformation(1:herdmovementrule_1,2)...
      ,'x'...
      ,herdmemberinformation((herdmovementrule_1+1):numberofprey,1) ...
      ,herdmemberinformation((herdmovementrule_1+1):numberofprey,2) ...
      ,'+');

    axis(main_figure_plot_axes,[0 360 ...
       0 360])
   
end
%-------------------------------------------------------------------
%--------------------------Plots Predator---------------------------
%-------------------------------------------------------------------
if simulationtype == 2 && (totalkills < killstoendhunt) && ...
   predator_spawned == 1 

 plot(main_figure_plot_axes,herdmemberinformation(1:herdmovementrule_1,1)...
      ,herdmemberinformation(1:herdmovementrule_1,2)...
      ,'x'...
      ,herdmemberinformation((herdmovementrule_1+1):numberofprey,1) ...
      ,herdmemberinformation((herdmovementrule_1+1):numberofprey,2) ...
      ,'+'...
      ,predatorinfo(:,1),predatorinfo(:,2),'mo','markerfacecolor','m');
  hold on
  if mod(timesteps_display,2) == 0
  plot(main_figure_plot_axes,predatorinfo(:,1),predatorinfo(:,2),...
      'm+','markerfacecolor','m','markersize',10)
  else
  plot(main_figure_plot_axes,predatorinfo(:,1),predatorinfo(:,2),...
      'mx','markerfacecolor','m','markersize',12)
  end
   hold off
  axis(main_figure_plot_axes,[0 360 ...
       0 360])

elseif simulationtype == 2 && (totalkills >= killstoendhunt) && ...
   predator_spawned == 1

plot(main_figure_plot_axes,herdmemberinformation(1:herdmovementrule_1,1)...
      ,herdmemberinformation(1:herdmovementrule_1,2)...
      ,'x'...
      ,herdmemberinformation((herdmovementrule_1+1):numberofprey,1) ...
      ,herdmemberinformation((herdmovementrule_1+1):numberofprey,2) ...
      ,'+'...
      ,predatorinfo(:,1),predatorinfo(:,2),'mo','markerfacecolor','m');
  hold on
  if mod(timesteps_display,2) == 0
  plot(main_figure_plot_axes,predatorinfo(:,1),predatorinfo(:,2),...
      'm+','markerfacecolor','m','markersize',10)
  else
  plot(main_figure_plot_axes,predatorinfo(:,1),predatorinfo(:,2),...
      'mx','markerfacecolor','m','markersize',12)
  end
   hold off
  axis(main_figure_plot_axes,[0 360 ...
       0 360])
   
end
end
pause(1/framerate)
end
end
%-------------------------------------------------------------------
%-------------------------------------------------------------------    
%------------Plots Herd And Predators For Each Time Loop------------   
%-------------------------------------------------------------------
%-------------------------------------------------------------------
%Controls end of simulation resets for stop button usage or the number of
%runs being simulated being reached
function simulation_reset(~,~)

    %Works Only If Close Button Hasn't Been Pressed
    if close_btn_pressed == 1
%Unlocks UI Sliders
set(btn5,'enable','on')
set(btn17,'enable','on')
set(btn9,'enable','on')

%Unlock Noise If Used
if mod(herdmovementrule,2) == 0 || mod(herdmovementrule2,2) == 0
set(btn34,'enable','on')
set(btn36,'enable','on','foregroundcolor',[0 0 0])
end
switch simulationtype
case 1
set(btn39,'enable','off') 
set(btn40,'enable','inactive')
case 2
set(btn39,'enable','on')
set(btn40,'enable','on','foregroundcolor',[0 0 0])
end
%Unlocks UI Imputs 
set(btn10,'enable','on','foregroundcolor',[0 0 0])
set(btn18,'enable','on','foregroundcolor',[0 0 0])
set(btn6,'enable','on','foregroundcolor',[0 0 0])
set(btn65b,'enable','on','foregroundcolor',[0 0 0])
%Unlocks UI Buttons
%Settings
set(btn72a,'enable','on')
set(btn72b,'enable','on')
set(btn22a,'enable','on')
set(btn22b,'enable','on')
set(btn42a,'enable','on')
set(btn42b,'enable','on')
%First Herd Movement Rules
set(btn12a,'enable','on')
set(btn12b,'enable','on')
set(btn12c,'enable','on')
set(btn12d,'enable','on')
%Second Herd Movement Rules
if simulationtype == 2
set(btn46a,'enable','on')
set(btn46b,'enable','on')
set(btn46c,'enable','on')
set(btn46d,'enable','on')
end
%Unlocks Run Buttons
set(btn35,'enable','on')
set(btn23,'enable','on')
%Set Run Buttons Indicators Back To Off
set(btn35back1,'backgroundcolor',[.75 .75 .75]);
set(btn35back2,'backgroundcolor',[.75 .75 .75]);
set(btn23back1,'backgroundcolor',[.75 .75 .75]);
set(btn23back2,'backgroundcolor',[.75 .75 .75]);     
 
if stopsimulation == 2
%Set Stop Buttons Indicators To On, Sets Stop Button Colors To B/W
set(btn66,'backgroundcolor','w','foregroundcolor','k')
set(btn66back1,'backgroundcolor',[0 1 0]);
set(btn66back2,'backgroundcolor',[0 1 0]);
end
    end
end    
%------------------------------------------------------------------------- 
%-------------------------------------------------------------------------
%--------------Saves Run Data And Results To A Seperate File--------------
%-------------------------------------------------------------------------
%-------------------------------------------------------------------------

%This Function Saves All Run Data For The Entire Data Collection Cycle
    function run_data_saving(~,~)
%-------------------------------------------------------------------------
%----------------Create Folder To Save Data To And Open It----------------
%-------------------------------------------------------------------------        
%Make save file folde and store current path to return to, then opens
%folder

cd(savepath)
[status,msg] = mkdir(filename);
cd(filename)
%-------------------------------------------------------------------------
%----------------Saves Run Data And Results To A .txt File----------------
%-------------------------------------------------------------------------
        
    fileID = fopen(strcat(filename,savefiletype_1),'w'); 
%Outputs line indicating That This Section Of The File Is For Tthe Files
%Save Name (Outputs Filename)
    fprintf(fileID,strcat(filename,savefiletype_1));
    fprintf(fileID,'\r\n');
%Outputs line indicating That This Section Of The File Is For Simulation
%Settings
    fprintf(fileID,'\r\n -------------------------------');
    fprintf(fileID,'\r\n ------Simulation Settings------ \r\n');
    fprintf(fileID,' -------------------------------');
if simulationtype == 1
    fprintf(fileID,'\r\n Simulation Type Was DOD \r\n');
%Saves Basic Run Settings (Number Of Animals, Runs And Timesteps,
%Movement Rule)
    if herdmovementrule == 1
    fprintf(fileID,'\r\n Movement Rule Used Was LCH \r\n');
    elseif herdmovementrule == 2
    fprintf(fileID,'\r\n Movement Rule Used Was LCH w/ Noise \r\n');
    elseif herdmovementrule == 3
    fprintf(fileID,'\r\n Movement Rule Used Was Voronoi \r\n');
    elseif herdmovementrule == 4
    fprintf(fileID,'\r\n Movement Rule Used Was Voronoi w/ Noise \r\n');
    end
%Herd data for non mixed herd testing
    fprintf(fileID,'\r\n Number Of Animals In Herd:');
    fprintf(fileID, ' %d ',numberofprey);
     
    fprintf(fileID,'\r\n Number Of Runs:');
    fprintf(fileID, ' %d ',numberofruns);
    
    fprintf(fileID,'\r\n Number Of Timesteps:');
    fprintf(fileID, ' %d ',timesteps);
   
    fprintf(fileID,'\r\n Noise Weight:');
    if noiseweight == -1
    fprintf(fileID, ' %g ',0);
    else
    fprintf(fileID, ' %g ',round(double(noiseweight),4));
    end
%Start Of Collected Data Output For DOD Runs 
    fprintf(fileID,'\r\n -------------------------------');
    fprintf(fileID,'\r\n --------Data Collection-------- \r\n');
    fprintf(fileID,' -------------------------------');
    
    fprintf(fileID,'\r\n Number Of Runs Currently Completed:');
    fprintf(fileID, ' %d ',runs);
    
    %Saves Percent Change In DOD    
    fprintf(fileID,'\r\n Percent of Herd Improving DOD For Each Run \r\n');
    fprintf(fileID,' %g ',...
        percentofherdmemberswithdecreasing_dod(:));
    
    %Saves Mean Percent Change In DOD    
    fprintf(fileID,...
'\r\n Mean Percent of Herd Improving DOD \r\n');
    fprintf(fileID,' %g ',...
        mean_percentofherdmemberswithdecreasing_dod);
    
    %Saves STD Of The Percent Change In DOD    
    fprintf(fileID,'\r\n Standard Deviation Over All Runs \r\n');
    fprintf(fileID,' %g ',...
        std_percentofherdmemberswithdecreasing_dod);

elseif simulationtype == 2   
    fprintf(fileID,'\r\n Simulation Type Was Mixed Herd \r\n');
%Reports herd composition for mixed herd testing
%Movement rules used by first herd
if herdmovementrule == 1
    fprintf(fileID,'\r\n 1st Movement Rule Used Was LCH ');
    elseif herdmovementrule == 2
    fprintf(fileID,'\r\n 1st Movement Rule Used Was LCH w/ Noise ');
    elseif herdmovementrule == 3
    fprintf(fileID,'\r\n 1st Movement Rule Used Was Voronoi ');
    elseif herdmovementrule == 4
    fprintf(fileID,'\r\n 1st Movement Rule Used Was Voronoi w/ Noise ');
end
%Movement rules used by second herd
if herdmovementrule2 == 5
    fprintf(fileID,'\r\n 2nd Movement Rule Used Was LCH \r\n');
    elseif herdmovementrule2 == 6
    fprintf(fileID,'\r\n 2nd Movement Rule Used Was LCH w/ Noise \r\n');
    elseif herdmovementrule2 == 7
    fprintf(fileID,'\r\n 2nd Movement Rule Used Was Voronoi \r\n');
    elseif herdmovementrule2 == 8
    fprintf(fileID,'\r\n 2nd Movement Rule Used Was Voronoi w/ Noise \r\n');
end
%Herd Data for mixed herd testing    
    fprintf(fileID,'\r\n Number Of Animals In The First Herd:');
    fprintf(fileID, ' %d ',herdmovementrule_1);
    
    fprintf(fileID,'\r\n Number Of Animals In The Second Herd:');
    fprintf(fileID, ' %d ',herdmovementrule_2);
    
    fprintf(fileID,'\r\n Number Of Runs:');
    fprintf(fileID, ' %d ',numberofruns);
     
    fprintf(fileID,'\r\n Number Of Timesteps Until Predator Appears:');
    fprintf(fileID, ' %d ',timesteps);
    
    fprintf(fileID,'\r\n Noise Weight:');
    if noiseweight == -1
    fprintf(fileID, ' %g ',0);
    else
    fprintf(fileID, ' %g ',round(double(noiseweight),4));
    end

%Start Of Data Collected Output For Mixed Herd Runs    
    fprintf(fileID,'\r\n -------------------------------');
    fprintf(fileID,'\r\n --------Data Collection-------- \r\n');
    fprintf(fileID,' -------------------------------');
        
    fprintf(fileID,'\r\n Number Of Runs Currently Completed:');
    fprintf(fileID, ' %d ',runs);
    %If mixed herd outputs number of dead by catagory
    if herdmovementrule == 1
    fprintf(fileID,strcat('\r\n Number of Dead Prey Following LCH',...
            ' Movement Rule:'));
    elseif herdmovementrule == 2
    fprintf(fileID,strcat('\r\n Number of Dead Prey Following LCH w/',...
            ' Movement Rule:'));
    elseif herdmovementrule == 3
    fprintf(fileID,strcat('\r\n Number of Dead Prey Following Voronoi',...
            ' Movement Rule:'));
    elseif herdmovementrule == 4
    fprintf(fileID,strcat('\r\n Number of Dead Prey Following Voronoi',...
            ' w/ Noise Movement Rule:'));
    end
    fprintf(fileID, ' %d ',total_deaths_rule_1);
%Movement rules used by second herd
if herdmovementrule2 == 5
    fprintf(fileID,strcat('\r\n Number of Dead Prey Following LCH',...
            ' Movement Rule:'));
    elseif herdmovementrule2 == 6
    fprintf(fileID,strcat('\r\n Number of Dead Prey Following LCH w/',...
            ' Movement Rule:'));
    elseif herdmovementrule2 == 7
    fprintf(fileID,strcat('\r\n Number of Dead Prey Following Voronoi',...
            ' Movement Rule:'));
    elseif herdmovementrule2 == 8
    fprintf(fileID,strcat('\r\n Number of Dead Prey Following Voronoi',...
            ' w/ Noise Movement Rule:'));
end
    fprintf(fileID, ' %d ',total_deaths_rule_2);
    
end

    fprintf(fileID,'\r\n \r\n End Of Data For Run \r\n \r\n');        
    

%Closes File    
    fclose(fileID);
    
%------------------------------------------------------------------------
%--------------------Saves UI Statistic Data And Plot--------------------
%------------------------------------------------------------------------
%If Data Saving Is On The Statistical Run Output And Data Is Saved At The
%End Of The Simulation

if runs == numberofruns
%Creates Invisible Figure To Plot On
fh2 = figure('visible','off');
fh2 = gcf;
figure_plot_axes = axes('parent',fh2,...
            'units','normal',...
            'position', [1/8 1/8 6/8 6/8]);  
        
%--First Save Statistics Image  
if simulationtype == 1
%Creates Histogram Plot   

%Plots Bar Graph
bar(figure_plot_axes,1:100,...
    sorted_percentofherdmemberswithdecreasing_dod) 
%Find First Non Zero Value And Last Non Zero Value For The Axis Of The Bar
%Plot
firstnon_0 = find(sorted_percentofherdmemberswithdecreasing_dod,1,'first');
lastnon_0 = find(sorted_percentofherdmemberswithdecreasing_dod,1,'last');

%Sets Up Tick marks
set(figure_plot_axes, ...      
        'xticklabelmode','auto',...
        'xtick',(firstnon_0 - 5):5:(lastnon_0 + 5),...
        'fontsize',12);
    
%Labels Axis
xlabel('Percent of Herd Improving DOD','fontsize',16)
ylabel('Cumulative Statistics','fontsize',16)
title('Domain of Danger Final Statistics','fontsize',16)
axis(figure_plot_axes, ...
[(firstnon_0 - 5) (lastnon_0 + 5) ...
 0 (max(sorted_percentofherdmemberswithdecreasing_dod) + 5)]) 

elseif simulationtype == 2
%Creates Death Count Plot 
bar(figure_plot_axes,1:2,...
    [total_deaths_rule_1 total_deaths_rule_2])  
   axis(figure_plot_axes, [0 3 ....
        0 (max([total_deaths_rule_1 total_deaths_rule_2]) + 5)])
   set(figure_plot_axes, ...
        'fontsize',12,...
        'xticklabel',({rule_1_string, rule_2_string}))
   xlabel('Herd Movement Rules','fontsize',16)
   ylabel('Number of Dead Prey','fontsize',16)   
   title('Mixed Herd Final Statistics','fontsize',16)
end
%Saves Staistaical Plot Data
print(fh2,strcat(filename,'_Statistics_Plot'),'-painters','-r300','-djpeg')

%--Saves Final Animation Image
if simulationtype == 1
%Creates Final Domain of Danger Animation 
voronoi(figure_plot_axes,...
        [transpose(herdmemberinformation(...
        (herdmemberinformation(:,1)~=0),1)),...
        transpose(mirrorpoints(:,1))],...
        [transpose(herdmemberinformation(...
        (herdmemberinformation(:,2)~=0),2)),...
         transpose(mirrorpoints(:,2))]);
title('Domain of Danger','fontsize',16)     
axis(figure_plot_axes,[0 360 ...
       0 360])  
%Saves Relevent Info For Replotting

elseif simulationtype == 2
%Creates Final Mixed Herd Animation 
plot(figure_plot_axes,herdmemberinformation(1:herdmovementrule_1,1)...
      ,herdmemberinformation(1:herdmovementrule_1,2)...
      ,'x'...
      ,herdmemberinformation((herdmovementrule_1+1):numberofprey,1) ...
      ,herdmemberinformation((herdmovementrule_1+1):numberofprey,2) ...
      ,'+'...
      ,predatorinfo(:,1),predatorinfo(:,2),'mo','markerfacecolor','m');
  hold on
  if mod(timesteps_display,2) == 0
  plot(figure_plot_axes,predatorinfo(:,1),predatorinfo(:,2),...
      'm+','markerfacecolor','m','markersize',10)
  else
  plot(figure_plot_axes,predatorinfo(:,1),predatorinfo(:,2),...
      'mx','markerfacecolor','m','markersize',12)
  end
  hold off
    axis(figure_plot_axes,[0 360 ...
       0 360])
  title('Mixed Herd','fontsize',16) 
end
%Sets Up Tick marks For Both Animations
set(figure_plot_axes, ...      
        'xticklabelmode','auto',...
        'xtick',(0:50:360),...
        'yticklabelmode','auto',...
        'ytick',(0:50:360),...
        'fontsize',12);
    xlabel(' ','fontsize',16)
    ylabel(' ','fontsize',16)

%Saves Animation Plot Data
print(fh2,strcat(filename,'_Animation_Plot'),'-painters','-r300','-djpeg')
%Close Figure
close(fh2)

end

%------------------------------------------------------------------------
%----------------------Returns To Original Filepath----------------------
%------------------------------------------------------------------------
%Changes directory to old one
cd(currentpath)
end    
    

end

%Endline For Main Function
end
