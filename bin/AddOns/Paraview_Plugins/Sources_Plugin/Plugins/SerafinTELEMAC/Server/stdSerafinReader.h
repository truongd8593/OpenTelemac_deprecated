/*=========================================================================

  Program:   Visualization Toolkit
  Module:    $RCSfile: stdSerafinReader.h,v $

  Copyright (c) Ken Martin, Will Schroeder, Bill Lorensen
  All rights reserved.
  See Copyright.txt or http://www.kitware.com/Copyright.htm for details.

     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notice for more information.

=========================================================================*/

////// Reader for files generated by The  TELEMAC modelling system \\\\\
// Module developped by herve ozdoba - Sept 2008 ( herve-externe.ozdoba at edf.fr / herve at ozdoba.fr )
// Please address all comments to Regina Nebauer ( regina.nebauer at edf.fr )
// >>> Test version

#ifndef __stdSerafinReader_h__
#define __stdSerafinReader_h__

/** -- Inclusions issues de la bibliothèque standard du C++ -- */

#include "FFileReader.h"

#include <fstream>
#include <string>
#include <cstdio>
#include <iostream>
#include <cstring>

using namespace std;

#include "vtkStringArray.h"
#include "vtkIntArray.h"
#include "vtkFloatArray.h"
#include "vtkStdString.h"
#include "vtkDoubleArray.h"
#include "vtkIntArray.h"
#include "vtkCellArray.h"
			 
/** ***************************************** **/
/** ********** A définir pour test ********** **/
/** ***************************************** **/

/// Veuillez décommentez la ligne suivante et compiler en mode exécutable pour effectuer des tests ///

#define 	___SIMPLE_READER_TEST_EXE___

/** -- Quelques définitions inhérantes au format Serafin standard -- **/

// Nombre maximum de caractères que peut avoir le titre d'une simulation sous Telemac.
#define 	TITLE_MAX_SIZE 	80

// Taille du bloc de description des discrétisations.
#define 	VAR_DESC_SIZE  	16

// Taille du bloc de définition des paramètres dans le fichier .
#define 	PARAM_NUMBER   	10

// Taille du bloc de définition des dates dans le fichier .
#define 	DATE_NUMBER   	6

//Taille des informations relatives aux discrétisations
#define 	DISC_DESC_SIZE  4

/** ********************************************************************************* **/
/** -- Definition des type utilisés pour la classe de lecture des fichiers Serafin -- **/
/** ********************************************************************************* **/

/// ci-dessous, voici une liste de types définis afin de faciliter le stockage des informations d'entête
/// d'un fichier Serafin en lecture .

// Définit le type de discrétisation utilisé dans le fichier
// TODO A revoir pour la dénormination
typedef enum 
{
	P0_Elem = 0, // >>> Serafin	
	P1_Elem = 1, // >>> Volfin
	P2_Elem = 2  // Pas encore implémenté
	
} SerafinDiscretizationType;/* enum_DiscretizationType */

// Définit la manière dont est définit la structure des données dans le fichier
// TODO A supprimer à l'avenir, existe à cause d'un petit malentendu au niveau de la compréhension du format Serafin
typedef enum 
{
	// La structuration des données est effectuée de manière temporelle .
	StructuredByTime = 0, /** Jamais le cas, obsolète !!!! **/
	
	// La structuration des données est effectuée de manière éclatée avec une répartition par variable .
	StructuredByVar  = 1 
	
} SerafinDataStructure;/* enum_DataStructure */

// Définit les informations sur une variables ;
typedef struct 
{
	char name[VAR_DESC_SIZE] ;
	char unit[VAR_DESC_SIZE] ;
	
} SerafinVar;/* struct_Var */

// Définit les informations relatives à une date précise
typedef struct 
{
	int	day  ;	int	month ;	int	year ;
	int	hour ;	int	min   ;	int	sec  ;
	
} SerafinDate;/* struct_Date */

// Définit une structure standard pour les meta-données (en considérant une seule discrétisation par fichier)
typedef struct 
{
	char  	Title[TITLE_MAX_SIZE] ; 		// le titre
	int   	VarNumber ; 				// le nombre de variables
	char* 	VarList ; 				// Un pointeur vers la liste des variables
	int	IParam[PARAM_NUMBER] ;  		// l'information IParam
	int	Date[DATE_NUMBER] ;			// La date du début de la simulation
	int	DiscretizationInfo[DISC_DESC_SIZE] ;	// Le informations de discrétisation (nombre d'éléments, nombre de points, ...)
	
} SerafinMetaData; /* struct_MetaData */

// Définit l'index général d'un fichier serafin pour faciliter le positionnement la de la lecture
typedef struct
{
	int FileSize ;			// taille du fichier
	int MetaSize ;			// taille des metadonnées
	int DataSize ;			// Taille totale des blocs de données
	int DataBlocSize ;		// Taille d'un bloc de données
	
	int ConnectivityPosition ;	// La position dans le fichier de la table de connectivité
	int XPosition;			// La position dans le fichier de la table des valeurs de X
	int YPosition;			// La position dans le fichier de la table des valeurs de Y
	int DataPosision;		// La position dans le fichier des blocs de données
	
	int NumberOfDate ;		// Information sur le temps étudié 
	
	// TODO La variable suivante n'a rien à faire dans cette stucture à mon avis mais je la laisse en attendant
	// Elle décrit le type de discrétisation qui est affecté lors de la création de l'index du fichier, d'où sa présence ici 
	SerafinDiscretizationType discretizationtype ;
	
} SerafinIndexInfo; /* struct_IndexInfo */

/** ********************************************************************************************* **/
/** -- Definition de la classe générique de traitement des fichiers externes au format Serafin -- **/
/** ********************************************************************************************* **/

/// Classe de lecture de fichier Serafin utilisée par le lecteur Serafin .
/// Elle parse l'entête du fichier pour recueillir les informations le concernant puis créer une table d'index qui 
/// permet la lecture des informations souhaitées .

// TODO Normaliser l'écriture des fonction avec un premier caractère en majuscule (pb mineur)

// Supprime les espaces à la fin d'une chaine
#define DeleteBlank(string, maxsize) \
	{int compteur = maxsize ; while(isspace(string[compteur-1])&&(compteur!= 0)) compteur --; string[compteur] = '\0';}

class stdSerafinReader : public FFileReader
{
public:
	// Simple constructeur (flux en argument)
	stdSerafinReader(ifstream* stream);
	
	// Destructeur de base
	~stdSerafinReader();
	
	// Renvoie 1 si le fichier est un fichier serafin 3D
	int Is3Dfile ()
	{		
		if (strstr ( this->metadata->VarList, "ELEVATION") != NULL ||  strstr (this->metadata->VarList, "COTE Z") != NULL ) return 1;
		return 0;
	};
	
	// Renvoie la variable associée à un identifiant dans la liste stockée dans le fichier Serafin 
	void GetVarById(const int id, SerafinVar* var)
	{
		if (id > GetNumberOfVars()) return;
		DeleteBlank((metadata->VarList+(id*VAR_DESC_SIZE*2)), 32);
		strcpy ( (char*)var, metadata->VarList+(id*VAR_DESC_SIZE*2) );
	};
	
	// Associe le nom de la variable selon le rang dans la table (name doit avoir 17 caractères disponibles )
	void GetVarNameById(const int id, char* name)
	{
		if (id > GetNumberOfVars()) return;
		memcpy ( name, metadata->VarList+(id*VAR_DESC_SIZE*2), VAR_DESC_SIZE );
		name[VAR_DESC_SIZE] = '\0' ;
	};
	
	// Associe l'unité de la variable selon le rang dans la table (unit doit avoir 17 caractère disponibles )
	void GetVarUnitById(const int id, char* unit)
	{
		if (id > GetNumberOfVars()) return;
		memcpy ( unit, metadata->VarList+(id*VAR_DESC_SIZE*2)+VAR_DESC_SIZE, VAR_DESC_SIZE );
		unit[VAR_DESC_SIZE] = '\0' ;
	};
	
	/* Ne fonctionne pas */
	int GetVarDim(const int id)
	{
		int i = 1;
		char nname[VAR_DESC_SIZE+1], name[VAR_DESC_SIZE+1];
		this->GetVarNameById(id, name);
		
		while ((id+i)<this->GetNumberOfVars())
		{
			this->GetVarNameById(id+i, nname);
			if(strncmp ( nname, name, 7 ) == 0) return i;
			i++;	
		}
		
		return i;
	}
	
	int getVelDim()
	{
		int i=0, j=0;
		char name[VAR_DESC_SIZE+1];	
		
		for(j=0; j<GetNumberOfVars(); j++)
		{
			this->GetVarNameById(j, name);
			if ((strstr ( name, "VELOCITY") != NULL || strstr ( name, "VITESSE") != NULL)&& strstr ( name, "SCALAR VELOCITY") == NULL ) i++;
		}
		return i;
	}
	
	int getSVelDim()
	{
		int i=0, j=0;
		char name[VAR_DESC_SIZE+1];	
		
		for(j=0; j<GetNumberOfVars(); j++)
		{
			this->GetVarNameById(j, name);
			if (strstr ( name, "SHEAR VELOCITY") != NULL) i++;
		}
		return i;
	}
	
	// Retourne le nombre de variables ( X e t Y exceptés )
	int 			  GetNumberOfVars() 		{return this->metadata->VarNumber;};
	
	// Associe le nom de la simulation à l'argument name .
	void			  GetTitle(char* name)		{strcpy(name, this->metadata->Title);};
	
	// Retourne la manière dont sont structurées les données dans le fichier
	SerafinDataStructure 	  GetNodeDataStructure()	{return (SerafinDataStructure)this->metadata->IParam[0];}
	
	// Retourne 1 si la date de début de la simulation est connue
	int			  HasDate()			{return (this->metadata->IParam[9] == 1);};
	
	// Associe la date de début de simulation
	void			  GetDate(SerafinDate* date)
	{
		date->day   = this->metadata->Date[2];	date->month = this->metadata->Date[1];	date->year  = this->metadata->Date[0];
		date->hour  = this->metadata->Date[3];	date->min   = this->metadata->Date[4];	date->sec   = this->metadata->Date[5];
	};
	
	// Simplifie la lecture des informations de discrétisation	
	int 			  GetNodeByElements() 		{return this->metadata->DiscretizationInfo[2];};
	int 			  GetNumberOfNodes() 		{return this->metadata->DiscretizationInfo[1];};
	int  		  GetNumberOfElement() 		{return this->metadata->DiscretizationInfo[0];};
	
	// Retourne le nombre de pas de temps
	int GetTotalTime() {return this->index->NumberOfDate;};
		
	// Retourne une date selon l'identifiant 'timeid' spécifié en argument
	float GetTime(int timeid) 
	{
		float value = 0;
		FileStream->seekg( this->index->DataPosision + this->index->DataBlocSize * timeid ,  std::ios_base::beg ) ; 
		skipReadingHeader(FileStream);
		(*this.*readFloatArray)(&(value), 1);
		return value;
	};
	
	
	// Lit les valeurs d'abscisse et les copie dans la table 'values' à partir de la position 'id' pour une taille 'size'
	int GetXValues(const int id, const int size, float* values)
	{
		GoToXPosition (id);(*this.*readFloatArray)(values, size);
		return FileStream->tellg();
	};
			
	// Lit les valeurs d'ordonnée et les copie dans la table 'values' à partir de la position 'id' pour une taille 'size'
	int GetYValues(const int id, const int size, float* values)
	{
		GoToYPosition (id);(*this.*readFloatArray)(values, size);
		return FileStream->tellg();
	};
	
	// Lit les valeurs de côte et les copie dans la table 'values' à partir de la position 'id' pour une taille 'size' à un temps 'time'
	// Retourne 0 et ne fait rien s'il s'agit d'un fichier 2D
	int GetZValues(const int id, const int size, float* values, int time)
	{
		if(!Is3Dfile ()) return 0;
		GoToData(time, 0, id);(*this.*readFloatArray)(values, size);
		return FileStream->tellg();
	}

	void WriteCoord(float *coords, const int time)
	{
		int i = 0;
		const int size = this->GetNumberOfNodes();
		float* arr = new float[size];
				
		// Ecriture des valeurs X
		this->GetXValues(0, size, arr);
		for (i=0;i<size;i++){coords[3*i] = arr[i];}
		
		// Ecriture des valeurs Y
		this->GetYValues(0, size, arr);	
		for (i=0;i<size;i++){coords[3*i+1] = arr[i];}	
			
		// Ecriture des valeurs Z
		this->GetZValues(0, size, arr, time);
		if (this->Is3Dfile ())
			for (i=0;i<size;i++){coords[3*i+2] = arr[i];}
		else
			for (i=0;i<size;i++){coords[3*i+2] = 0;}
	}
	
	void GetVarRangeValues(const int size, const int range, const int varid, float *coords, const int time)
	{
		int i = 0, j=0;
		float* arr = new float[size];
		
		for (int i=0; i<range; i++)
		{
			this->GetVarValues(time, varid+i, 0, arr, size);
			for (j=0;j<size;j++){coords[3*j+i] = arr[j];}
		}
		
		if(range<3)
			for (j=0;j<size;j++){coords[3*j+2] = 0;}
	}
	
	void WriteConnectivity(int *values)
	{
		this->GoToConnectivityPosition (0);
		(*this.*readIntArray)(values, this->GetNodeByElements()*this->GetNumberOfElement());
	}
	
	// Lit les valeurs de la variable de discrétisation identifiée par 'idvar' et les copie dans la table 'values' à partir de la position 'id'
	// pour une taille 'size' à un temps 'time'
	int GetVarValues(const int time, const int idvar, const int id, float* values, const int size)
	{
		GoToData(time, idvar, id);(*this.*readFloatArray)(values, size);
		return FileStream->tellg();
	};
	
	// Retourne le type de discretisation utilisé
	// A revoir ...
	SerafinDiscretizationType GetDiscretizationType(){return this->index->discretizationtype; };
	// SerafinDiscretizationType GetDiscretizationType() 	{return (SerafinDiscretizationType)this->metadata->DiscretizationInfo[3];};
			
	// TODO A terme, placer ces variables en protected
	SerafinMetaData* metadata ;
	SerafinIndexInfo* index ;

protected:
	stdSerafinReader(); // Non implementée ;
	
	// Lit l'ensemble des metadonnées et  retourne la position actuelle
	// Cette méthode est appelée dès l'instanciation pour gérer une bonne fois pour toutes les métadonnées
	int readMetaData ();
	
	// Créer l'index du fichier Serafin
	void createIndex ();

	////// Ensemble de fonction de lecture de la table d'index \\\\\\
	
	// [fixés] Déplace la tête de lecture sur la positon id dans la table des valeurs de X ou Y
	int GoToXPosition (const int id) {FileStream->seekg( this->index->XPosition +4*(1+id),  std::ios_base::beg ) ;return FileStream->tellg();};
	int GoToYPosition (const int id) {FileStream->seekg( this->index->YPosition +4*(1+id),  std::ios_base::beg ) ;return FileStream->tellg();};
	
	// [fixé] Déplace la tête de lecture sur l'élément N dans la table de connectivité
	int GoToConnectivityPosition (const int N) 
	{
		FileStream->seekg( this->index->ConnectivityPosition +4 * (1+N*GetNodeByElements()),  std::ios_base::beg ) ;
		return FileStream->tellg();
	};
	
	// TODO Améliorer les trois méthodes ci-dessous
	
	// Déplace la tête de lecture sur un bloc de données en fonction du temps spécifié en argument
	int GoToData(const int time)
	{
		if (time >= GetTotalTime()) return 0 ;
		FileStream->seekg( this->index->DataPosision + this->index->DataBlocSize * time + 12,  std::ios_base::beg ) ; 
		return FileStream->tellg();
	};
	
	// Déplace la tête de lecture sur un bloc de données en fonction du temps et de l'identifiant de variable spécifiés en argument
	int GoToData(const int time, const int idvar)
	{
		int blocNode = 4 * GetNumberOfNodes() + 8 ;
		int blocElem = 4 * GetNumberOfElement() + 8 ;
		
		GoToData(time); 
		if (idvar >= GetNumberOfVars()) return 0 ;
		if (this->index->discretizationtype == P0_Elem) 
		{
			FileStream->seekg( blocNode * idvar,  std::ios_base::cur ) ;
			return FileStream->tellg();
		} 
		
		if (Is3Dfile ()) FileStream->seekg( blocElem * (idvar-1) + blocNode ,  std::ios_base::cur );
		else		 FileStream->seekg( blocElem * idvar		    ,  std::ios_base::cur );
		
		return FileStream->tellg();		
	};
	
	// Déplace la tête de lecture sur un bloc de données en fonction du temps, de l'identifiant de variable et du point spécifiés en argument 
	int GoToData(const int time, const int idvar, const int id)
	{
		GoToData(time, idvar);
		FileStream->seekg( 4*(1+id),  std::ios_base::cur ) ;
		return FileStream->tellg();
	};

	
	
private :
	
	stdSerafinReader(const stdSerafinReader&);	// Pas implémentée
	void operator=(const stdSerafinReader&);  	// Pas implémentée
	
}; /* class_stdSerafinReader */

#endif