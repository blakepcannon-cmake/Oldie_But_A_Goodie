# Created by: Sean Bowman and Blake Cannon on 7/11/2013

###########################################################################
# Median polish (two-way effects)
###########################################################################

# Fun fact: I learned this technique from Dr. Karen Kafadar, who was the 
# last doctoral student of Dr. John Tukey, the person who created this technique. 
# Dr. Tukey did a couple other things in life such as inventing the boxplot
# and terming "byte".

# Median polishing is an exploratory data analysis technique for gridded 
# data. It results in an additive decomposition of the data into several 
# parts by subtracting the medians of each row from the row values, then 
# the medians of the columns from the column values and recording them as 
# row effect and column effect variables. This process is repeated until 
# convergence, that is until the row and column medians are 0 or close. 
# The medians of the row effects and column effects variables are then 
# added to give the all effect variable, and subtracted from the row effects 
# and column effects variables. Because median polishing uses medians rather 
# than means, it is robust to outliers. This might be confusing at this point
# and I would suggest watching this video for visualization of the process. 
# http://www.youtube.com/watch?v=RtC9ZMOYgk8 
# For now, let's precede.

# Questions
# Which dose and schedule of Abraxane do you routinely use in patients with
# the following aggressive metastatic disease features? Select one dose.

#	Age <= 50 years at diagnosis
#		(a) <=90 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(b) 100 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(c) 125 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(d) 150 mg/m^2 days 1, 8, and 15 every 4 weeks
#		(e) 260 mg/m^2 every 3 weeks

#	Short disease free interval (< 6 months)
#		(a) <=90 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(b) 100 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(c) 125 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(d) 150 mg/m^2 days 1, 8, and 15 every 4 weeks
#		(e) 260 mg/m^2 every 3 weeks

#	Predominant visceral metastases
#		(a) <=90 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(b) 100 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(c) 125 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(d) 150 mg/m^2 days 1, 8, and 15 every 4 weeks
#		(e) 260 mg/m^2 every 3 weeks

#	Comorbidities/performance status
#		(a) <=90 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(b) 100 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(c) 125 mg/m^2 days 1, 8, & 15 every 4 weeks
#		(d) 150 mg/m^2 days 1, 8, and 15 every 4 weeks
#		(e) 260 mg/m^2 every 3 weeks

# Each physician will select one dose/schedule for each of the four
# questions listed above. Results would be better illustrated using a 
# contingency table. Hypothetically, lets create some data from n=100 
# physicians responding to these questions. Therefore, we will have
# n=100 physicians responding to four questions, giving us a total of
# n=400 responses. Below is our data in column form.

under50<-c(5,15,45,30,5) # Age <= 50 years at diagnosis
diseaseFree<-c(40,45,10,3,2) # Short disease free interval (<= 6 months)
visceral<-c(10,25,45,15,5) # Predominant visceral metastases
comorbidities<-c(5,10,20,45,20) # Comorbidities/performance status

# Counts based by predictors

data<-cbind(under50,diseaseFree,visceral,comorbidities)
row.names(data)<-c("90mg","100mg","125mg","150mg","260mg")

# The data in table format:

#       under50 diseaseFree visceral comorbidities
# 90mg        5          40       10             5
# 100mg      15          45       25            10
# 125mg      45          10       45            20
# 150mg      30           3       15            45
# 260mg       5           2        5            20

###########################################################################
# Ready for the median polish
###########################################################################

# Research question that clients struggled to voice:
# What is the relationship between the four conditions and level 
# of dosage/schedule?

# Parameters:
# x = the data in table/matrix format
# eps = real number greater than 0. A tolerance for convergence
# maxiter = the maximum number of iterations (three to four is usually enough)
# trace.iter = logical. should progress in convergence be reported?
# na.rm = logical. should missing values be removed?

medPolish<-medpolish(x=data, eps=0.01,maxiter=10,trace.iter=TRUE,na.rm=FALSE)

# Median Polish Results (Dataset: "data")

# Overall: 17.5

# There is an overall effect of 17.5 between dosage and condition.

# Row Effects:
#   90mg  100mg  125mg  150mg  260mg 
# -11.25   0.00  13.75   2.50 -13.75 

# From the row effects, we can see that based on these five conditions
# there is an overall positive effect for prescription dosages for 125mg and
# 150mg, and negative effects for 260mg and 90mg. There was not an effect for
# 100mg. In other words, more physicians prescribe 125mg and 150mg of 
# Abraxane among patients with the four conditions, and less Abraxane 
# for 90mg and 260mg. 

# Column Effects:
#   under50   diseaseFree   visceral comorbidities 
#    1.25         -1.75       3.75      -1.25 

# From the column effects, we can see that based on these four conditions
# visceral and under50 pts have positive effects on dosage, while 
# diseaseFree and comorbidities have negative effect on dosage. Therefore, 
# we can say that physicians prescribe more Abraxane for those patients 
# <= 50 years at diagnosis or who have predominant visceral metastases 
# when considering dosage-level and condition. Moreover, patients who've 
# experienced a disease free interval (<6 months) or have 
# comorbidities/performance status are prescribed less Abraxane when 
# considering dosage-level and condition.

# Residuals:
#         under50   diseaseFree  visceral comorbidities
# 90mg      -2.50        35.50      0.00      0.00
# 100mg     -3.75        29.25      3.75     -6.25
# 125mg     12.50       -19.50     10.00    -10.00
# 150mg      8.75       -15.25     -8.75     26.25
# 260mg      0.00         0.00     -2.50     17.50

# The individual residual effects are the meat and potatoes for the median 
# polish technique. From the above table, we can learn so much about the 
# relationship between dosage-level and condition type. For example, we can 
# see that physicians prescribe higher dosages for comorbidities 260mg (17.50) 
# and 150mg (26.25) across the four conditions and five dosage-levels.

# Question: Why not just look at the frequencies? 
# Let's refer back to are original table now.

#          under50 diseaseFree visceral comorbidities
# 90mg        5          40       10             5
# 100mg      15          45       25            10
# 125mg      45          10       45            20
# 150mg      30           3       15            45
# 260mg       5           2        5            20

# Let me highlight two cells in particular. Under comorbidities for 125mg 
# and 260mg, we can see that both values are "20". However, the effects 
# are completely opposite when considering the four conditions. There is 
# a positive effect of 17.50 for 260mg and a negative effect of -10.00 for 
# 125mg. This allows us to infer that across these four conditions, physicians 
# prescribe 125mg of Abraxane less frequently and 260mg more
# frequently when considering the other three conditions. As we can see, 
# the median polish is a great technique for exploring 
# two-way relationships among physician dosing and patient condition type.

# Let's do some plotting, shall we?

# Combining the two plots for row and column effects
par(mfrow=c(1,2))

# For row main effects
matplot(medPolish$row,main="Main Effects for Dosage-level",ylab="Residual Effect",col=cbind("black"),xlab="Abraxane Dosage-level (mg/m^2)",xaxt="n",type="h",lty=1,lwd=2,cex=1.5,cex.axis=1,cex.lab=1.5,cex.main=2,cex.sub=1,pch=16,col.main="black",font.main=3)
axis(1,at=1:5,labels=c("90","100","120","150","260"))
abline(0,0,lty=2,lwd=4)
grid(nx=NULL,ny=NULL,lty=6,lwd=1,col="lightgrey")
legend("topright",c("Effects of dosage-level"),cex=0.75,pch=16,col=c("red2","royalblue4","palegreen4","orange2"))
points(medPolish$row,pch=21,cex=2,lwd=1,col="black",bg="red2")
text(x=c(1,2,3,4,5),y=medPolish$row,label=medPolish$row,pos=3,offset=.5,font=2)

# For column main effects
matplot(medPolish$col,main="Main Effects for Condition Type",ylab="Residual Effect",col=cbind("black"),xlab="Condition Type",xaxt="n",type="h",lty=1,lwd=2,cex=1.5,cex.axis=1,cex.lab=1.5,cex.main=2,cex.sub=1,pch=16,col.main="black",font.main=3)
axis(1,at=1:4,labels=c("under50","diseaseFree","visceral","comorbidities"))
abline(0,0,lty=2,lwd=4,col="black")
grid(nx=NULL,ny=NULL,lty=6,lwd=1,col="lightgrey")
legend("topright",c("Effects of condition type"),cex=0.75,pch=16,col=c("red2","royalblue4","palegreen4","orange2"))
points(medPolish$col,pch=21,cex=2,lwd=1,col="black",bg="red2")
text(x=c(1,2,3,4,5),y=medPolish$col,label=medPolish$col,pos=3,offset=.5,font=2)

# For the residuals
matplot(medPolish$residuals,main="Residual Effects for Condition & Dosage-level",ylab="Residual Effect",col=cbind("red2","royalblue4","palegreen4","orange2"),xlab="Abraxane Dosage-level (mg/m^2)",xaxt="n",type="o",lty=1,lwd=1,cex=1.5,cex.axis=1,cex.lab=1.5,cex.main=2,cex.sub=1,pch=16,col.main="black",font.main=3)
axis(1,at=1:5,labels=c("90","100","120","150","260"))
abline(0,0,lty=2,lwd=2)
grid(nx=NULL,ny=NULL,lty=6,lwd=1,col="lightgrey")
legend("topright",c("under50","diseaseFree","visceral","comorbidities"),cex=0.75,pch=16,col=c("red2","royalblue4","palegreen4","orange2"))

#Example from 67151 - Part 1 data
matplot(medPolish$residuals,main="Residual Effects for Relevance Across Story",ylab="Residual Effect",col=cbind("red2","royalblue4","palegreen4","orange2"),
	xlab="Relevance Rating",xaxt="n",type="o",lty=1,lwd=1,cex=1.5,cex.axis=1,cex.lab=1.5,cex.main=2,cex.sub=1,pch=16,col.main="black",font.main=3)
axis(1,at=1:7,labels=paste("Rate", 1:7, sep=" "))
abline(0,0,lty=2,lwd=2)
grid(nx=NULL,ny=NULL,lty=6,lwd=1,col="lightgrey")
legend("topright",paste("Story", c("A", "R", "S"), sep=" "),cex=0.75,pch=16,col=c("red2","royalblue4","palegreen4","orange2"))


#Beautiful barplot
barplot(data,main="Dosage by Condition Type",ylab="Frequency",xlab="Condition Type", angle=c(45, 135), density=30, 
        col=c("red2","blue","palegreen4","orange2","black"), names=c("under50","diseaseFree","visceral","comorbidities"))
legend(0.4, 38, c("90 mg", "100 mg","120 mg","150 mg","260 mg"),fill=c("red2","blue","palegreen4","orange2","black"), cex=1.5,
       angle = c(135, 45), density = 30)
