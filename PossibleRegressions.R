# All possible regressions selection procedure

attach(flir_group1_long)
head(flir_group1_long)
#install.packages("leaps")
library(leaps)
library(MASS)
detach(flir_combined)

# Model with some variables of my choosing
M1=lm(aveOralM~Humidity+T_atm+Distance+T_FH_Max+T_FHC_Max+canthiMax+T_Max)
summary(M1)

#----------------------
# Step wise regression # CODE RAN: DONE
#----------------------
step(lm(aveOralM ~ . - SubjectID, data = flir_group1_long), direction = "both")

##or using library(MASS)

stepAIC(lm(aveOralM~. - SubjectID,data=flir_group1_long),direction="both") 


#----------------------
#Forward selection      # CODE RAN: DONE
#----------------------
mint <- lm(aveOralM~1,data=flir_group1_long)
forwardAIC <- step(mint,scope=list(lower=~1, 
                                   upper=~aveOralM~Humidity+T_atm+Distance+Cosmetics+T_FH_Max+T_FHC_Max+canthiMax+T_Max),
                   direction="forward", data=flir_group1_long)

#or

forwardAIC1 <- step(mint,scope=formula(M1),
                    direction="forward", data=flir_group1_long)

forwardAIC1$coefficients
forwardAIC$coefficients
forwardAIC1$anova
forwardAIC$anova



#---------------------
#Backward Elimination # CODE RAN: DONE
#---------------------

step(lm(aveOralM~Humidity+T_atm+Distance+Cosmetics+T_FH_Max+T_FHC_Max+canthiMax+T_Max,data=flir_group1_long),direction="backward")
##Best Subset

X <- cbind(Humidity+T_atm+Distance+Cosmetics+T_FH_Max+T_FHC_Max+canthiMax+T_Max)

#Model=regsubsets(as.matrix(X),aveOralM, nvmax = 8) BIG NOTE: THIS MARK ME ERROR

#or
Model=regsubsets(aveOralM~Humidity+T_atm+Distance+Cosmetics+T_FH_Max+T_FHC_Max+canthiMax+T_Max,data=flir_group1_long, nvmax = 10)
summary(Model)
SUM=summary(Model)
names(SUM)
Rsq=SUM$rsq
CP=SUM$cp
AdRsq=SUM$adjr2
BIC=SUM$bic
RSS=SUM$rss
#Calculation of AIC
n <- length(flir_group1_long$aveOralM)
p <- apply(SUM$which, 1, sum)
AIC<- SUM$bic - log(n) * p + 2 * p
#number of independent variables in the models
I=p-1
I
MSE1=RSS/(n-I-1)
MSE1



###Plot
graphics.off()
#dev.new()
par(mar=c(4, 4, 2, 2)) 
plot(p,Rsq,xlab="Subset Size",ylab="Adjusted R-squared", pch=19, col="blue")
plot(p,Rsq,xlab="Subset Size",ylab="R-squared", pch=19, col="blue")
plot(p,CP,xlab="Subset Size",ylab="CP", pch=19, col="blue")
lines(y=p+1,x=p, col="red")
plot(p,PRESS,xlab="Subset Size",ylab="PRESS", pch=19, col="blue")


##PRESS
m1=lm(aveOralM~Humidity)
s1=summary(m1)
m2=lm(aveOralM~Humidity+T_atm)
s2=summary(m2)
m3=lm(aveOralM~Humidity+T_atm+Distance)
s3=summary(m3)
m4=lm(aveOralM~Humidity+T_atm+Distance+Cosmetics)
s4=summary(m4)
m5=lm(aveOralM~Humidity+T_atm+Distance+Cosmetics+T_FH_Max)
s5=summary(m5)
m6=lm(aveOralM~Humidity+T_atm+Distance+Cosmetics+T_FH_Max+T_FHC_Max)
s6=summary(m6)
m7=lm(aveOralM~Humidity+T_atm+Distance+Cosmetics+T_FH_Max+T_FHC_Max+canthiMax)
s7=summary(m7)
m8=lm(aveOralM~Humidity+T_atm+Distance+Cosmetics+T_FH_Max+T_FHC_Max+canthiMax+T_Max)
s8=summary(m8)


#install.packages("qpcR")
library(qpcR)
n1=qpcR::PRESS(m1)
a1=n1$stat
b1=s1$sigma
n2=qpcR::PRESS(m2)
a2=n2$stat
b2=s2$sigma
n3=qpcR::PRESS(m3)
a3=n3$stat
b3=s3$sigma
n4=qpcR::PRESS(m4)
a4=n4$stat
b4=s4$sigma
n5=qpcR::PRESS(m5)
a5=n5$stat
b5=s5$sigma
n6=qpcR::PRESS(m6)

a6=n6$stat
b6=s6$sigma
n7=qpcR::PRESS(m7)
a7=n7$stat
b7=s7$sigma
n8=qpcR::PRESS(m8)
a8=n8$stat
b8=s8$sigma

PRESS=c(a1,a2,a3,a4,a5,a6,a7,a8)
MSE=(c(b1, b2, b3, b4, b5, b6, b7, b8))^2
##Result
cbind(SUM$which,round(cbind(Rsq,AdRsq,CP,BIC,RSS,AIC, PRESS, MSE,MSE1),4))



