#mergeoutput files from BLCA
library(tidyverse)
library(stringr)
library="na12s_teleo_l1_SWARM3"
defaul=read.csv(file=paste(library,"_defaul.csv",sep=""),header = F)
ist97=read.csv(file=paste(library,"_iset97.csv",sep=""),header = F)
ist99.5=read.csv(file=paste(library,"_iset99.5.csv",sep=""),header = F)
defaul= defaul %>% select(V1,V3,V4,V6,V7,V9,V10,V12,V13,V15,V16,V21,V22)
colnames(defaul)=c("OTU","phylum","ident.ph","class","ident.cl","order","ident.or","family","ident.fa","genus","ident.ge","species","ident.sp")
ist97= ist97 %>% select(V1,V3,V4,V6,V7,V9,V10,V12,V13,V15,V16,V21,V22)
colnames(ist97)=c("OTU","phylum.97","ident.ph.97","class.97","ident.cl.97","order.97","ident.or.97","family.97","ident.fa.97","genus.97","ident.ge.97","species.97","ident.sp.97")
ist972=ist97 %>%select("OTU","order.97","ident.or.97","family.97","ident.fa.97","genus.97","ident.ge.97","species.97","ident.sp.97")
blca_assignment=left_join(defaul,ist97,by="OTU")

ist99.5= ist99.5 %>% select(V1,V3,V4,V6,V7,V9,V10,V12,V13,V15,V16,V21,V22)
colnames(ist99.5)=c("OTU","phylum.99","ident.ph.99","class.99","ident.cl.99","order.99","ident.or.99","family.99","ident.fa.99","genus.99","ident.ge.99","species.99","ident.sp.99")

ist99.52=ist99.5 %>%select("OTU","order.99","ident.or.99","family.99","ident.fa.99","genus.99","ident.ge.99","species.99","ident.sp.99")
blca_assignment2=left_join(blca_assignment,ist99.52,by="OTU")
write_csv(blca_assignment2,file=paste(library,"_merge.csv",sep=""))

defaul[is.na(defaul)]<-0
ist97[is.na(ist97)]<-0
ist99.5[is.na(ist99.5)]<-0

blca_assignment_merge=data.frame(OTU=defaul$OTU,phylum=NA,ident.ph=0,class=NA,ident.cl=0,order=NA,ident.or.99=0,family=NA,ident.fa=0,genus=NA,ident.ge=0,species=NA,ident.sp=0)
for (i in 1:length(defaul$OTU)) {
  if(ist97[i,13]>defaul[i,13]) blca_assignment_merge[i,]= ist97[i,]
  else blca_assignment_merge[i,]= defaul[i,] 
  
}
for (i in 1:length(defaul$OTU)) {
  if(ist99.5[i,13]>ist97[i,13]) blca_assignment_merge[i,]= ist99.5[i,]
}
write_csv(blca_assignment_merge,file=paste(library,"_90to99.5.csv"))