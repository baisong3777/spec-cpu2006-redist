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
 * $Log: XMLDTDDescriptionImpl.cpp,v $
 * Revision 1.2  2003/10/14 15:20:42  peiyongz
 * Implementation of Serialization/Deserialization
 *
 * Revision 1.1  2003/06/20 18:39:33  peiyongz
 * Stateless Grammar Pool :: Part I
 *
 * $Id: XMLDTDDescriptionImpl.cpp,v 1.2 2003/10/14 15:20:42 peiyongz Exp $
 *
 */


// ---------------------------------------------------------------------------
//  Includes
// ---------------------------------------------------------------------------
#include <xercesc/validators/DTD/XMLDTDDescriptionImpl.hpp>

XERCES_CPP_NAMESPACE_BEGIN

// ---------------------------------------------------------------------------
//  XMLDTDDescriptionImpl: constructor and destructor
// ---------------------------------------------------------------------------
XMLDTDDescriptionImpl::XMLDTDDescriptionImpl(const XMLCh* const   rootName
                                           , MemoryManager* const memMgr)
:XMLDTDDescription(memMgr)
,fRootName(0)
{
    if (rootName)
        fRootName = XMLString::replicate(rootName, memMgr);
}

XMLDTDDescriptionImpl::~XMLDTDDescriptionImpl()
{
    if (fRootName)
        XMLGrammarDescription::getMemoryManager()->deallocate((void*)fRootName);
}
             
const XMLCh* XMLDTDDescriptionImpl::getGrammarKey() const
{
    return getRootName();
}
              
const XMLCh* XMLDTDDescriptionImpl::getRootName() const
{ 
    return fRootName; 
}

void XMLDTDDescriptionImpl::setRootName(const XMLCh* const rootName)
{
    if (fRootName)
        XMLGrammarDescription::getMemoryManager()->deallocate((void*)fRootName);   

    fRootName = XMLString::replicate(rootName, XMLGrammarDescription::getMemoryManager()); 
}        

/***
 * Support for Serialization/De-serialization
 ***/

IMPL_XSERIALIZABLE_TOCREATE(XMLDTDDescriptionImpl)

void XMLDTDDescriptionImpl::serialize(XSerializeEngine& serEng)
{
    XMLDTDDescription::serialize(serEng);

    if (serEng.isStoring())
    {
        serEng.writeString(fRootName);
    }
    else
    {
        serEng.readString((XMLCh*&)fRootName);
    }

}

XMLDTDDescriptionImpl::XMLDTDDescriptionImpl(MemoryManager* const memMgr)
:XMLDTDDescription(memMgr)
,fRootName(0)
{
}

XERCES_CPP_NAMESPACE_END
