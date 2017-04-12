# Name: $RCSfile: find_evidences.sh,v $
# CVS file: $Source: /usr/local/cvs/stable/informix/accessment/scripts/find_evidences.sh,v $
# CVS id: $Header: /usr/local/cvs/stable/informix/accessment/scripts/find_evidences.sh,v 1.1 2011/03/09 10:46:42 fnunes Exp $
# Revision: $Revision: 1.1 $
# Revised on: $Date: 2011/03/09 10:46:42 $
# Revised by: $Author: fnunes $
# Support: Fernando Nunes - domusonline@gmail.com
# Licence: This script is licensed as GPL ( http://www.gnu.org/licenses/old-licenses/gpl-2.0.html )
# History:

ONLINELOG=$1

#grep -v -e "Checkpoint Completed:" -e "^$" -e "loguniq [0-9][0-9]*, logpos .*, timestamp" -e "Maximum server connections" -e "Checkpoint Statistics" -e "Logical Log [0-9][0-9]* Complete" $ONLINELOG
grep -v -e "Checkpoint Completed:" -e "^$" -e "loguniq [0-9][0-9]*, logpos .*, timestamp" -e "Maximum server connections" -e "Checkpoint Statistics" -e "Logical Log [0-9][0-9]*" $ONLINELOG
