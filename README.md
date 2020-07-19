# power-grid-analysis
Simulation and analysis of a typical European electricity distribution network with variations in EV adoption and PV penetration rate with the aim to answer the following question:

### What is the expected cost to upgrade the electricity distribution network to make it viable in the context of an increasing electrification of our way of life as well as to support the growing decentralized renewable production?

**Authors:** 
Pierre Crucifix & Arnaud Debray, within a global project carried out by Pierre Crucifix (Mathematical Engineer), Arnaud Debray (Energy Engineer) and Sophie Delcorte (Business Developer)


**What is shown here:** 
This github repo presents a power-flow simulation with an analysis of a typical European electricity distribution network based on the European Low Voltage Test Feeder topology coupled with corrected real consumption data from 1145 households, solar production and electric vehicles consumptions.


## 1. Origin of data and cleaning
The most crucial data from this model are the household quarter-hourly measures about their electricity consumption. Indeed, it is quite easy to find average - or sometimes individual - annual electricity consumption, but it will hide all seasonality phenomena based on hours, day of the week, official holiday, weather, seasons, and so on. From this observation, it is rather clear it is almost impossible to create a good model of a typical household consumption without data measuring it accurately over time. The problem with this kind of data is that it can reveal a lot of information about the private lives of households. So, even if a lot of measures have already been done over the past years around the world, it is a rare resource to gather for people like you and me.

However, thanks to the DiSC framework developed by the l’IEEE Task Force on Open Source Software for Power
Systems within Aalborg University, household electricity consumption data with 4 measures/hour of 1145 Danish households for over more than two years are publicly available at this address: http://kom.aau.dk/project/SmartGridControl/DiSC/download.html [*Credit*: R. Pedersen, C. Sloth, G. B. Andresen and R. Wisniewski, “DiSC: A Simulation Framework for Distribution System Voltage Control”. in Proceedings of the 2015 European Control Conference, Linz, Austria, July, 2015.]

This data is a treasure trove for research on this type of analysis. However, they cannot be directly used due to some data corruption withing the (77733 * 1145) matrix aggregating all quarter-hourly consumption data. To tackle this, we realized a pre-processing dealing with negative data (improbable due to the fact the households are pure consumer, not producers in any way) and too high measure points. This pre-processing was mainly based on household consumption averages and time-period consumption average among all the 1145 households, supposing not all sensors had problem simultaneously.

## 2. Model Components
With these real cleaned consumption data at our disposal, it remains to set up the grid on which we we perform the simulations as well as to create PV production models (solar panels) and to add EV (Electric Vehicles) consumption. This is all the more important considering a network designed today is supposed to last several decades, and so, to be able to support an increasing production from solar panels by household owners and EV consumption by considering a progressive electrification of the car fleet. Note these two phenomena, implying both considerable amount of energy, follow the tendency to to be concomitant within the same neighbourhood. Our model will take this fact into account.

For all the following simulations, we will focus on the IEEE European Low Voltage Test Feeder topology. A diagram of this topology is given on the figure below.

![IEEEoriginalTopology](https://github.com/pierre-crucifix/power-grid-analysis/blob/master/Figures/IEEEoriginalTopology.PNG "Logo Title Text 1")

An adaptation of this topology was given in the case of this project in order to fit as much as possible with the network configurations from South of Belgium. It required an electrical expertise to design the different technical components as well as the whole structure connecting each electrical component. This adaptation, with houses represented by red triangles, is shown below.


![IEEEsimplifiedTopology](https://github.com/pierre-crucifix/power-grid-analysis/blob/master/Figures/IEEEsimplifiedTopology.PNG "Logo Title Text 1")

From there, the model allows to insert any type of electricity consumer (or even producer) at the red triangles places.


### 2a. Solar Production

As introduced at the beginning of this section, our model includes solar producers within household owners. The model is quite complete, taking into account direct radiation illumination, diffuse illumination and even diffuse illumination from parts of the sky covered by clouds, as well as the hour and day of the year, and of course, the geographic location of the house plus the weather (through rains and clouds). With all these data, we are able to compute the power production per solar panel.

Over our simulations, we change in a random way the proportion of solar panel owners as well as their location. In addition, we also allow changes in the orientation of the home neighboorhood over the simulations. We furthermore took into account the fact it is often whole streets that take profit of a South exposition as the next figure highlights one possible situation.

![OrientationExample](https://github.com/pierre-crucifix/power-grid-analysis/blob/master/Figures/OrientationExample.png "Logo Title Text 1")



### 2b. Household Consumption
The household consumption data used for the simulations are the one presented in the first section. We ensured the similitude of Danish consumption with Belgian ones based on annual electricity consumptions as well as socio-economic factors.

### 2c. Electric Vehicles Charge
As said earlier, the network is analyzed with a long-term vision. It means we have taken into account a democratization of electric vehicles and developed a model based on several factors (daily travel per vehicle, battery capacity consumption linked with these travels, plus the periods vehicles stay at home thanks to the LINEAR project - You can read the super relevant report of this project for our one at this address: https://www.energyville.be/sites/energyville/files/downloads/2020/boekje_linear_okt_2014_boekje_web.pdf)


## 3. Power flow simulations

All the simulations used the MATPOWER open-source framework (See https://matpower.org and https://github.com/MATPOWER/matpower). This framework is exclusive to Matlab and is the reason why all the analysis was done with this software.


## 4. Analysis of the results

From the simulations, we extracted problem reports including the circumstances of problems (line currents and node voltage). From these reports, we realized a statistical analysis quantifying the necessary upgrade expenses for a functional network. This analysis imposes a 100% functional network over time in 99.9% of the simulations, each simulation representing one year. The quantification is possible thanks to the data retrieved from a local Distribution System Operator (DSO) about the price of each component of the network. Of course, this percentage threshold can be chose by the DSO according to its preferences in the trade off between cost and stability.

The more detailed results analysing the whole Walloon electricity distribution networks are left confidential at this time mainly by their commercial interest in the project of setting up a company carrying out this type of analysis. For more information, visit http://hdl.handle.net/2078.1/thesis:19419 about this research project.


### Code structure
The following diagram gives a global overview of the data processing workflow:

<p align="center">
  <img height="900" src="https://github.com/pierre-crucifix/power-grid-analysis/blob/master/Figures/DataProcessingWorkflow.png">
</p>

As you could observe, the diagram is split in four parts, just are this README and the code folders. This choice is not insignificant and allows a better comprehension of the whole
 
 


