#!/bin/csh -f
# ############################################################
setenv ens_size 50
setenv buffer 30 # keep $buffer number of matched file in directory. 
setenv scp_num 24 # scp file number.

setenv REGION    eastAsia
setenv EXPT      2022ozone
setenv REG_DIR       /scratch/lililei4/haoxing/wrfchem_exps/${REGION}
setenv EXP_DIR_TOP   ${REG_DIR}/${EXPT}/30d_50ens_6h_fcst     

setenv   REL_DIR              /share/home/lililei4/models_wrfchem
setenv   WRFVAR_DIR           ${REL_DIR}/WRFDA/
setenv   UPDATE_BC_DIR        ${WRFVAR_DIR}/var/da
setenv   TOOL_DIR             ${WRFVAR_DIR}/var/da
 
setenv START_DATE 2022071000
setenv LAST_DATE 2022081000

recheck:
@ ii =1
while ( $ii <= $ens_size )
  set WORK_DIR = $EXP_DIR_TOP/$ii/
  cd $WORK_DIR
  echo "--------- WORK_DIR IS NOW: $WORK_DIR ---------"

  set f_num = `ls -d $PWD/wrfout* | wc -l`
  if ($f_num < $buffer) then 
    @ ii ++
    continue # loop over other member.sleep when loop over, not now.
  endif
  ###### scp part
  set DATADIR = /ldata4/llleistu/haoxing/$EXPT/$ii/
  set scp_list = `ls -d $PWD/wrfout* | head -n $scp_num`
  echo "SCP_LIST IS -------> $scp_list "
  /share/apps.20191030bak/sshpass-1.06/bin/sshpass -p 'lilic503' scp $scp_list llleistu@114.212.48.200:${DATADIR}/

  if ( $status != 0 ) then
    echo "ERROR in $WORK_DIR : scp failed..." 
    touch ./AUTOSCP_FAIL
    exit 1
  else
    echo "--------- remove proc DONE in $WORK_DIR -----------"
  endif
  ###### delete part
  set delete_list = `ls -d $PWD/wrfout* | head -n $scp_num`
  echo "DELETE_LIST IS -------> $delete_list "
  rm -f $delete_list

  if ( $status != 0 ) then
    echo "ERROR in $WORK_DIR : delete failed..." 
    touch ./AUTOSCP_FAIL
    exit 1
  else
    echo "--------- remove proc DONE in $WORK_DIR -----------"
  endif
   
  @ ii ++
end
sleep 180
goto recheck

