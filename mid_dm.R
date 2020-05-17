library(dplyr)
library(prcomp)
raw <- read.csv("raw.csv")

# 1. Ÿ�ٺ��� ����ġ ó�� �� ����
raw <- rename(raw, ingest = LS_1YR)
raw$ingest <- ifelse(raw$ingest == 9, NA, raw$ingest)
raw <- raw %>% filter(!is.na(ingest))

raw <- raw %>% filter(age > 18) 

#[�Ҿ�û�ҳ���� ��ȯ������ ����]
raw <- raw %>% select(-DI9_yd) #�ڵ�� : DI9_yd 
raw <- raw %>% select(-DI9_ya) #�ڵ�� : DI9_ya 
raw <- raw %>% select(-DF1_yd) #�ڵ�� : DF1_yd 
raw <- raw %>% select(-DF1_ya) #�ڵ�� : DF1_ya 
raw <- raw %>% select(-DN6_yd) #�ڵ�� : DN6_yd
raw <- raw %>% select(-DN6_ya) #�ڵ�� : DN6_ya 
raw <- raw %>% select(-DJ9_yd) #�ڵ�� : DJ9_yd 
raw <- raw %>% select(-DJ9_ya) #�ڵ�� : DJ9_ya 
#[����ġ ����]
raw <- raw %>% select(-wt_hs) 
raw <- raw %>% select(-wt_itvex) 
raw <- raw %>% select(-wt_pft) 
raw <- raw %>% select(-wt_vt) 
raw <- raw %>% select(-wt_nn) 
raw <- raw %>% select(-wt_ntr) 
raw <- raw %>% select(-wt_tot) 
raw <- raw %>% select(-wt_pfnt) 
raw <- raw %>% select(-wt_pfvtnt) 
raw <- raw %>% select(-wt_pfvt) 
raw <- raw %>% select(-wt_vtnt) 
raw <- raw %>% select(-wt_nnnt) 
#�Ҿ�û�ҳ� ü�� �������
raw <- raw %>% select(-HE_wt_pct,-HE_BMI_pct,-LQ4_01,-LQ4_02 ,- LQ4_03, -  LQ4_04,   -LQ4_05 , - LQ4_06 ,  -LQ4_07,   -LQ4_08  , -LQ4_09,   -LQ4_10   ,-LQ4_11 , - LQ4_12  , -LQ4_13  , -LQ4_14 , - LQ4_15 ,-  LQ4_16  ,- LQ4_21 , - LQ4_22 ,  -LQ4_25,  - LQ4_26,  - LQ4_27  , -LQ4_28 , - LQ4_29,   -LQ4_23 , - LQ4_24 ,-  LQ4_17 ,-  LQ4_18 ,-  LQ4_19,  - LQ4_20)
raw <- raw %>% select(-id_F ,-  id_M) 
raw <- raw %>% select(-EC_wht_6)#�����ٷνð� : ��Ÿ��
raw <- raw %>% select(-BH9_14_1_01,-BH9_14_1_02,-BH9_14_1_03,BH9_14_2_01,-BH9_14_3_01,-BH9_14_4_01,-BH9_14_2_02,-BH9_14_2_03,-BH9_14_4_02,-BH9_14_2_03,BH9_14_3_03)

raw <- raw %>% select(-CH2_1,-CH2_2)
raw <- raw %>% select(-BO3_11)#ü���������: ��Ÿ ��
raw <- raw %>% select(-BD7_67)#"1�Ⱓ Ÿ���� ���ַ� ���� 
# ���� ����: ��Ÿ ��4)
raw <- raw %>% select(-BP2_2)#��Ʈ���� ����: ��Ÿ��1)
raw <- raw %>% select(-BS12_35)#(����)������������: ��Ÿ��
raw <- raw %>% select(-BS12_45)#(����)������������: ��Ÿ��
raw <- raw %>% select(-BS10_1, -BS10_3,-BS10_2)#û�ҳ� ��������
raw <- raw %>% select(-LW_mp_e)#��������� ��Ÿ
#���м�����
raw <- raw %>% select(-HE_alt_etc)
raw <- raw %>% select(-HE_hsCRP_etc)
raw <- raw %>% select(-HE_Folate_etc)
raw <- raw %>% select(-HE_NNAL_etc)
raw <- raw %>% select(-HE_UNa_etc)
raw <- raw %>% select(-BM13_6)#ġ�Ƽջ� ����: ��Ÿ��
raw <- raw %>% select(-BM14_2)#"ġ������ ��ġ�� ���� ��Ÿ��
#�Ļ��� �ְ���
raw <- raw %>% select(-N_DT_DS)
raw <- raw %>% select(-N_DT_ETC)
#w��������׸�����
raw <- raw %>% select(-mod_d)
raw <- raw %>% select(-X)
raw <- raw %>% select(-ID)
raw <- raw %>% select(-ID_fam)

dim(raw)

###############################################################
# 2. 8,88,888, 9,99,999 NaN�۾� 
# 1) ������ �и� -> 8,88,888,9,99,999�� ����� �� �Ǵ� ������ �и�
a <- raw %>% select(age, region, LK_LB_IT, LQ2_ab, AC8_3w_01, AC8_3w_02 ,AC8_3w_03 )
c <- raw %>%  select(-age, -region, -LK_LB_IT, -LQ2_ab,-AC8_3w_01,-AC8_3w_02,-AC8_3w_03 )
c[c==8 | c==88 | c==888 | c==8888 | c=='8888'] <- NA
c[c==9 | c==99 | c==999 | c==9999 | c=='9999'] <- NA

# 2) �и� �� ����
raw2 <- cbind(c, a) 
raw2$LK_LB_IT <- ifelse(raw2$LK_LB_IT == 88, 0, 1) # binarization
raw2 <- rename(raw2, love_nutri = LK_LB_IT)

##############################################################
# 3. ������ ��ó�� - �ķ��� ��Ģ�� ���� Nan�� ����
raw3 <- raw2
dim(raw3) # 5708 521

# 1�� ����
sorted<-sort(colSums(is.na(raw3)),decreasing = TRUE)
delete <- sorted[1:120]
deletecolname <- names(delete)
raw3<-raw3 %>% select(-deletecolname)

i<-1
while(i<nrow(raw3)& nrow(raw3)>1141&ncol(raw3)>130){ 
  sorted <- sort(rowSums(is.na(raw3)),decreasing=TRUE)
  
  if(sum(is.na(raw3[i,]))>sorted[length(sorted)*0.2]){
    raw3<-raw3[-i,]
  }
  i = i+1
}
raw3$ainc
dim(raw3) # 4534 521

# 2�� ����
sorted<-sort(colSums(is.na(raw3)),decreasing = TRUE)
delete <- sorted[1:120]
deletecolname <- names(delete)
raw3<-raw3 %>% select(-deletecolname)

i<-1
while(i<nrow(raw3)& nrow(raw3)>1000&ncol(raw3)>104){ 
  sorted <- sort(rowSums(is.na(raw3)),decreasing=TRUE)
  
  if(sum(is.na(raw3[i,]))>sorted[length(sorted)*0.2]){
    raw3<-raw3[-i,]
  }
  i = i+1
}

dim(raw3) # 3600 417

# 3�� ����
sorted<-sort(colSums(is.na(raw3)),decreasing = TRUE)
delete <- sorted[1:120]
deletecolname <- names(delete)
raw3<-raw3 %>% select(-deletecolname)

i<-1
while(i<nrow(raw3)& nrow(raw3)>1000&ncol(raw3)>83){ 
  sorted <- sort(rowSums(is.na(raw3)),decreasing=TRUE)
  
  if(sum(is.na(raw3[i,]))>sorted[length(sorted)*0.2]){
    raw3<-raw3[-i,]
  }
  i = i+1
}

dim(raw3) # 2903 334
table(is.na(raw3))

# 3�� ����
sorted<-sort(colSums(is.na(raw3)),decreasing = TRUE)
delete <- sorted[1:120]
deletecolname <- names(delete)
raw3<-raw3 %>% select(-deletecolname)

i<-1
while(i<nrow(raw3)& nrow(raw3)>1000&ncol(raw3)>83){ 
  sorted <- sort(rowSums(is.na(raw3)),decreasing=TRUE)
  
  if(sum(is.na(raw3[i,]))>sorted[length(sorted)*0.2]){
    raw3<-raw3[-i,]
  }
  i = i+1
}
sorted<-sort(colSums(is.na(raw3)),decreasing = TRUE)
delete <- sorted[1:30]
deletecolname <- names(delete)
raw3<-raw3 %>% select(-deletecolname)

# ������ �������̱�
raw4 <- raw3
# 1) PCA �м�

data <- raw4%>% select(N_INTK,   N_EN,   N_WATER,   N_PROT,   N_FAT,   N_SFA,   N_MUFA,   N_PUFA,   N_N3,   N_N6,   N_CHOL,   N_CHO,   N_TDF,   N_SUGAR,   N_CA,   N_PHOS,   N_FE,   N_NA,   N_K,   N_VA,   N_VA_RAE,   N_CAROT,   N_RETIN,   N_B1,   N_B2,   N_NIAC,   N_VITC)

scaled_data <- as.data.frame(scale(data))

#pca�м� ����
scaled_data.pca <- prcomp(scaled_data, scale. = T)

#�����л�Ȯ���� 70~90%�̳����� PC��� ���Խ�Ű��
summary(scaled_data.pca)
plot(scaled_data.pca, type = "l")

#PC��ҵ� ���Ժ��� ���õ� ���������� ���� �� ���� ���� ���� Ȯ��
sort(abs(scaled_data.pca$rotation[,1]), decreasing = TRUE)#energy_protein
sort(abs(scaled_data.pca$rotation[,2]), decreasing = TRUE)#fat_series
sort(abs(scaled_data.pca$rotation[,3]), decreasing = TRUE)#vitamin_A
sort(abs(scaled_data.pca$rotation[,4]), decreasing = TRUE)#n-dim-fattyAcid


#�����л� 70%�� �Ѵ� �ּ��� PC���ҵ� ����
PCA <- as.data.frame(scaled_data.pca$x[,1:4])
PCA
raw5<-cbind(raw4,PCA)

raw5 <- raw5%>% select(-N_INTK, -N_EN, -N_WATER, -N_PROT,   -N_FAT,   -N_SFA,   -N_MUFA,   -N_PUFA,   -N_N3,   -N_N6,   -N_CHOL,   -N_CHO,   -N_TDF,   -N_SUGAR,   -N_CA,   -N_PHOS,   -N_FE,   -N_NA,   -N_K,  -N_VA,   -N_VA_RAE,  -N_CAROT,   -N_RETIN,  -N_B1,   -N_B2,   -N_NIAC,   -N_VITC)

# 2) min-max ����ȭ
normalize<-function(x){
  return ((x-min(x))/(max(x)-min(x)))
}
temp$HE_ht<-normalize(temp$HE_ht)
temp$HE_wt<-normalize(temp$HE_wt)
temp$HE_BMI<-normalize(temp$HE_BMI)

# 3) Factor level�� �ʹ� ���� ���� ����
raw5 <- raw5 %>% select(-psu,-DC11_tp,-M_2_et,-BS5_31,-N_DAY,-AC3_3e_01)
raw5 <- raw5 %>% select(-kstrata) # ����ġ�� �ʿ� ����
raw5 <- raw5 %>% select(-DC12_tp,-AC8_1e_01,-AC3_3e_02,
                        -HE_Uacid_etc,-HE_Ucot_etc,-HE_Ukal_etc) # �� ��ĭ�̶� ����

str(raw5)
# 4) ���� 2��ȭ (�ߺ�, ����)
temp <- raw5 %>% select(region)
temp <- as.data.frame(temp)
temp$region <- ifelse(temp$region %in% c(1,4,6,8,9,11,12),1 , 0)
temp <- rename(temp, top_bottom_region = region)
datas2 <- cbind(raw5,temp)
str(raw5)

# 5) ���̸� 3 class�� �з��ؼ� ���� ����
temp <- raw5 %>% select(age)
temp <- as.data.frame(temp)
temp$age <- ifelse(temp$age > 65, 'old', ifelse(temp$age > 30, 'middle', 'young'))
temp <- rename(temp, age_group = age)
raw5 <- cbind(raw5,temp)
str(raw5)

# 6) �ҵ� �̻�ġ ����
raw5$ainc <- ifelse(raw5$ainc < 16.6667| raw5$ainc > 1301, NA, raw5$ainc)#�̻�ġ����
raw5 <- rename(raw5, earn_month = ainc)
raw5<-raw5%>% filter(!is.na(earn_month))

# 7) ����ȯ
sperate <- raw5 %>% select(earn_month, HE_ht, HE_wt, HE_BMI, PC1, PC2, PC3, PC4, age)
sperate # �и��� ��
sperate_name <- names(sperate) # �и��� �̸�
change <- raw5 %>% select(-sperate_name) # factor�� �ٲ� ���̺�
str(change) 
change_name <- names(change) # factor�� �ٲ� �̸�

for(i in change_name){
  change[,i] <- as.factor(change[,i]) # ����ȯ
}

# change + sperate ����
processed <- cbind(change, sperate)
str(processed)

# ���� ������ �ٽ� ����
processed <- processed %>% select(-incm,-ho_incm,-ho_incm5,-incm5,-cfam,-genertn,ainc_1,-BA2_22,-HE_obe,-L_OUT_FQ,-LF_secur_y,)
#########################################################
# 4. �ǻ���� ���� �𵨸�
library(caret)
library(tree)
library(party)
library(rpart)
library(caret)
library(rpart.plot)

df <- processed
# train, test �и�
set.seed(50) #reproducability setting
intrain2<-createDataPartition(y=temp$target_ingest, p=0.9, list=FALSE) 
train_temp<-temp[intrain2, ]
test_temp<-temp[-intrain2, ]
View(train_temp)
# �ǻ�������� �׸���
rpartmod2<-rpart(target_ingest~. , data=train_temp, method="class")
plot(rpartmod2)
text(rpartmod2)
printcp(rpartmod2)
plotcp(rpartmod2)

# ���� �ּҰ����� ����ġ��
ptree<-prune(rpartmod, cp= rpartmod$cptable[which.min(rpartmod$cptable[,"xerror"]),"CP"])
plot(ptree)
text(ptree)
# ��
rpartpred<-predict(rpartmod2, test_temp, type='class')
test_temp$target_ingest<-as.factor(test$target_ingest)
confusionMatrix(rpartpred, temp$target_ingest)

prp(ptree,type=1,extra=2,digits=3) # ����ġ�� �Ѱ� �̻ڰ�
prp(rpartmod2,type=1,extra=2,digits=3) # ����ġ�� �� �̻ڰ�