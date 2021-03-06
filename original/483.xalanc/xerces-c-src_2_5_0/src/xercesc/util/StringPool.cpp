/*
 * The Apache Software License, Version 1.1
 *
 * Copyright (c) 1999-2003 The Apache Software Foundation.  All rights
 * reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 *
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 *
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in
 *    the documentation and/or other materials provided with the
 *    distribution.
 *
 * 3. The end-user documentation included with the redistribution,
 *    if any, must include the following acknowledgment:
 *       "This product includes software developed by the
 *        Apache Software Foundation (http://www.apache.org/)."
 *    Alternately, this acknowledgment may appear in the software itself,
 *    if and wherever such third-party acknowledgments normally appear.
 *
 * 4. The names "Xerces" and "Apache Software Foundation" must
 *    not be used to endorse or promote products derived from this
 *    software without prior written permission. For written
 *    permission, please contact apache\@apache.org.
 *
 * 5. Products derived from this software may not be called "Apache",
 *    nor may "Apache" appear in their name, without prior written
 *    permission of the Apache Software Foundation.
 *
 * THIS SOFTWARE IS PROVIDED ``AS IS'' AND ANY EXPRESSED OR IMPLIED
 * WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED.  IN NO EVENT SHALL THE APACHE SOFTWARE FOUNDATION OR
 * ITS CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
 * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
 * USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
 * OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
 * SUCH DAMAGE.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation, and was
 * originally based on software copyright (c) 1999, International
 * Business Machines, Inc., http://www.ibm.com .  For more information
 * on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 */

/*
 * $Log: StringPool.cpp,v $
 * Revision 1.9  2004/01/29 11:48:46  cargilld
 * Code cleanup changes to get rid of various compiler diagnostic messages.
 *
 * Revision 1.8  2003/12/17 00:18:35  cargilld
 * Update to memory management so that the static memory manager (one used to call Initialize) is only for static data.
 *
 * Revision 1.7  2003/10/29 16:18:41  peiyongz
 * Implement serialization/deserialization
 *
 * Revision 1.6  2003/10/09 13:49:30  neilg
 * make StringPool functions virtual so that we can implement a synchronized version of StringPool for thread-safe updates.
 *
 * Revision 1.5  2003/05/18 14:02:05  knoaman
 * Memory manager implementation: pass per instance manager.
 *
 * Revision 1.4  2003/05/16 06:01:52  knoaman
 * Partial implementation of the configurable memory manager.
 *
 * Revision 1.3  2003/05/15 19:07:45  knoaman
 * Partial implementation of the configurable memory manager.
 *
 * Revision 1.2  2002/11/04 15:22:04  tng
 * C++ Namespace Support.
 *
 * Revision 1.1.1.1  2002/02/01 22:22:12  peiyongz
 * sane_include
 *
 * Revision 1.6  2001/10/22 15:43:35  tng
 * [Bug 3361] "String pool id was not legal" error in Attributes::getURI().
 *
 * Revision 1.5  2000/07/07 22:16:51  jpolast
 * remove old put(value) function.  use put(key,value) instead.
 *
 * Revision 1.4  2000/05/15 22:31:20  andyh
 * Replace #include<memory.h> with <string.h> everywhere.
 *
 * Revision 1.3  2000/03/02 19:54:46  roddey
 * This checkin includes many changes done while waiting for the
 * 1.1.0 code to be finished. I can't list them all here, but a list is
 * available elsewhere.
 *
 * Revision 1.2  2000/02/06 07:48:04  rahulj
 * Year 2K copyright swat.
 *
 * Revision 1.1.1.1  1999/11/09 01:05:10  twl
 * Initial checkin
 *
 * Revision 1.2  1999/11/08 20:45:14  rahul
 * Swat for adding in Product name and CVS comment log variable.
 *
 */


// ---------------------------------------------------------------------------
//  Includes
// ---------------------------------------------------------------------------
#include <xercesc/util/StringPool.hpp>
#include <assert.h>

XERCES_CPP_NAMESPACE_BEGIN

// ---------------------------------------------------------------------------
//  StringPool::PoolElem: Constructors and Destructor
// ---------------------------------------------------------------------------
XMLStringPool::PoolElem::PoolElem( const   XMLCh* const string
                                 , const unsigned int id
                                 , MemoryManager* const manager) :
    fId(id)
    , fString(0)
    , fMemoryManager(manager)
{
    fString = XMLString::replicate(string, fMemoryManager);
}

XMLStringPool::PoolElem::~PoolElem()
{
    fMemoryManager->deallocate(fString); //delete [] fString;
}

// ---------------------------------------------------------------------------
//  StringPool::PoolElem: Public methods
// ---------------------------------------------------------------------------

void
XMLStringPool::PoolElem::reset(const XMLCh* const string, const unsigned int id)
{
    fId = id;
    fMemoryManager->deallocate(fString);//delete [] fString;
    fString = XMLString::replicate(string, fMemoryManager);
}



// ---------------------------------------------------------------------------
//  XMLStringPool: Constructors and Destructor
// ---------------------------------------------------------------------------
XMLStringPool::XMLStringPool(const  unsigned int  modulus,
                             MemoryManager* const manager) :

    fMemoryManager(manager)
    , fIdMap(0)
    , fHashTable(0)
    , fMapCapacity(64)
    , fCurId(1)
{
    // Create the hash table, passing it the modulus
    fHashTable = new (fMemoryManager) RefHashTableOf<PoolElem>(modulus, fMemoryManager);

    // Do an initial allocation of the id map and zero it all out
    fIdMap = (PoolElem**) fMemoryManager->allocate
    (
        fMapCapacity * sizeof(PoolElem*)
    ); //new PoolElem*[fMapCapacity];
    memset(fIdMap, 0, sizeof(PoolElem*) * fMapCapacity);
}

XMLStringPool::~XMLStringPool()
{
    delete fHashTable;
    fMemoryManager->deallocate(fIdMap); //delete [] fIdMap;
}


// ---------------------------------------------------------------------------
//  XMLStringPool: Pool management methods
// ---------------------------------------------------------------------------
unsigned int XMLStringPool::addOrFind(const XMLCh* const newString)
{
    PoolElem* elemToFind = fHashTable->get(newString);
    if (elemToFind)
        return elemToFind->fId;

    return addNewEntry(newString);
}


bool XMLStringPool::exists(const XMLCh* const newString) const
{
    return fHashTable->containsKey(newString);
}

bool XMLStringPool::exists(const unsigned int id) const
{
    if (!id || (id >= fCurId))
        return false;

    return true;
}

void XMLStringPool::flushAll()
{
    fCurId = 1;
    fHashTable->removeAll();
}


unsigned int XMLStringPool::getId(const XMLCh* const toFind) const
{
    PoolElem* elemToFind = fHashTable->get(toFind);
    if (elemToFind)
        return elemToFind->fId;

    // Not found, so return zero, which is never a legal id
    return 0;
}


const XMLCh* XMLStringPool::getValueForId(const unsigned int id) const
{
    if (!id || (id >= fCurId))
        ThrowXMLwithMemMgr(IllegalArgumentException, XMLExcepts::StrPool_IllegalId, fMemoryManager);

    // Just index the id map and return that element's string
    return fIdMap[id]->fString;
}

unsigned int XMLStringPool::getStringCount() const
{
    return fCurId-1;
}

// ---------------------------------------------------------------------------
//  XMLStringPool: Private helper methods
// ---------------------------------------------------------------------------
unsigned int XMLStringPool::addNewEntry(const XMLCh* const newString)
{
    // See if we need to expand the id map
    if (fCurId == fMapCapacity)
    {
        // Calculate the new capacity, create a temp new map, and zero it
        const unsigned int newCap = (unsigned int)(fMapCapacity * 1.5);
        PoolElem** newMap = (PoolElem**) fMemoryManager->allocate
        (
            newCap * sizeof(PoolElem*)
        ); //new PoolElem*[newCap];
        memset(newMap, 0, sizeof(PoolElem*) * newCap);

        //
        //  Copy over the old elements from the old map. They are just pointers
        //  so we can do it all at once.
        //
        memcpy(newMap, fIdMap, sizeof(PoolElem*) * fMapCapacity);

        // Clean up the old map and store the new info
        fMemoryManager->deallocate(fIdMap); //delete [] fIdMap;
        fIdMap = newMap;
        fMapCapacity = newCap;
    }

    //
    //  Ok, now create a new element and add it to the hash table. Then store
    //  this new element in the id map at the current id index, then bump the
    //  id index.
    //
    PoolElem* newElem = new (fMemoryManager) PoolElem(newString, fCurId, fMemoryManager);
    fHashTable->put((void*)(newElem->getKey()), newElem);
    fIdMap[fCurId] = newElem;

    // Bump the current id and return the id of the new elem we just added
    fCurId++;
    return newElem->fId;
}

/***
 * Support for Serialization/De-serialization
 ***/

IMPL_XSERIALIZABLE_TOCREATE(XMLStringPool)

void XMLStringPool::serialize(XSerializeEngine& serEng)
{
    /***
     * Since we are pretty sure that fIdMap and fHashTable is 
     * not shared by any other object, therefore there is no owned/referenced
     * issue. Thus we can serialize the raw data only, rather than serializing 
     * both fIdMap and fHashTable.
     *
     * And we can rebuild the fIdMap and fHashTable out of the raw data during
     * deserialization.
     *
    ***/
    if (serEng.isStoring())
    {
        serEng<<fCurId;
        for (unsigned int index = 1; index < fCurId; index++)
        {
            const XMLCh* stringData = getValueForId(index);
            serEng.writeString(stringData);
        }
    }
    else
    {
        unsigned int mapSize;
        serEng>>mapSize;
        assert(1 == fCurId);  //make sure empty

        for (unsigned int index = 1; index < mapSize; index++)
        {
            XMLCh* stringData;
            serEng.readString(stringData);
            addNewEntry(stringData);            
        }
    }
}

XMLStringPool::XMLStringPool(MemoryManager* const manager) :
    fMemoryManager(manager)
    , fIdMap(0)
    , fHashTable(0)
    , fMapCapacity(64)
    , fCurId(1)
{
    // Create the hash table, passing it the modulus
    fHashTable = new (fMemoryManager) RefHashTableOf<PoolElem>(109, fMemoryManager);

    // Do an initial allocation of the id map and zero it all out
    fIdMap = (PoolElem**) fMemoryManager->allocate
    (
        fMapCapacity * sizeof(PoolElem*)
    ); //new PoolElem*[fMapCapacity];
    memset(fIdMap, 0, sizeof(PoolElem*) * fMapCapacity);
}

XERCES_CPP_NAMESPACE_END
