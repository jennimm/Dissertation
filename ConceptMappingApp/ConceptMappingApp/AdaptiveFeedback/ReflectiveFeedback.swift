//
//  ReflectiveFeedback.swift
//  ConceptMappingApp
//
//  Created by Jennifer on 07/02/2023.
//

import Foundation

struct ReflectiveFeedback {

    func BeliefPromtRethinkWrite(learnerBelief: String) -> (String, String) {
        let title = "You believe that: '" + learnerBelief + "'."
        
        // two question options to implement
        let feedback_info = "Think about the keywords you might have missed.\n" + "Do you insist on your belief?"

        return (title, feedback_info)
    }
    
    func ErrorTaskRelatedQuestion(response: ResponseCategorisationValues, learnersBelief: String, expertBelief: String) -> String {
        var feedback_info = ""
        let removeCharacters: Set<Character> = [".", "!", "?", ",", ":", "*", "/"]
        
        print(learnersBelief)
        if response == .InComplete {
            let keywords = getKeywords(sentence: learnersBelief)
            feedback_info = "Do you believe that your concept contains only the parts: " + keywords + "?"
        } else if response == .InAccurate || response == .InCompleteInAccurate{
            feedback_info = "Do you believe: '" + learnersBelief + "'? \n Or do you believe: '" + expertBelief + "'. \nDo you agree with your concept?"
        } else if response == .InAccurateSuperfluous {
            var user_keywords = getKeywords(sentence: learnersBelief)
            
            user_keywords.removeAll(where: { removeCharacters.contains($0) } )
            var expert_keywords = getKeywords(sentence: expertBelief)
            expert_keywords.removeAll(where: { removeCharacters.contains($0) } )
            var extra_words: [String] = []
            for i in 0..<user_keywords.count {
                if !expert_keywords.contains(user_keywords[user_keywords.index(user_keywords.startIndex, offsetBy: i)]) {
                    extra_words.append(String(user_keywords[user_keywords.index(user_keywords.startIndex, offsetBy: i)]))
                }
            }
            feedback_info = "Do you want to reconsider the parts: " + extra_words.joined(separator: ", ") + " in your answer: '" + learnersBelief + "'?"
        }
        return feedback_info
    }
    
    func getKeywords(sentence: String) -> String {
        let wordsToRemove = ["a", "at", "the", "and", "it", "a", "about", "above", "after", "again", "against", "all", "am", "an", "and", "any", "are", "aren't", "as", "be", "because", "been", "before", "being", "below", "between", "both", "but", "by", "can't", "cannot", "could", "couldn't", "did", "didn't", "do", "does", "doesn't", "doing", "don't", "down", "during", "each", "few", "for", "from", "further", "had", "hadn't", "has", "hasn't", "have", "haven't", "having", "here", "here's", "how", "how's", "i", "i'd", "i'll", "i'm", "i've", "if", "in", "into", "is", "is:", "isn't", "it", "it's", "its", "itself", "let's", "more", "most", "mustn't", "of", "off", "on", "once", "only", "or", "other", "ought", "out", "over", "own", "shan't", "should", "shouldn't", "so", "some", "such", "than", "that", "that's", "the", "their", "theirs", "them", "themselves", "then", "there", "there's", "these", "they", "they'd", "they'll", "they're", "they've", "this", "those", "through", "to", "too", "under", "until", "up", "very", "was", "wasn't", "we", "we'd", "we'll", "we're", "we've", "were", "weren't", "what", "what's", "when", "when's", "where", "where's", "which", "while", "who", "who's", "whom", "why", "why's", "with", "won't", "would", "wouldn't", "you", "you'd", "you'll", "you're", "you've", "your", "yours", "yourself", "yourselves", "*", "num."]
        let _: Set<Character> = [".", "!", "?", ",", ":", "*", "/"]
        
        let components: String = sentence
        let components_arr = components.components(separatedBy: " ")
        var words: [String] = []
        for i in 0..<components_arr.count {
            words.append(String(components_arr[components_arr.index(components_arr.startIndex, offsetBy: i)].lowercased()))
        }
        
        let user_keywords = words.filter({ wordsToRemove.contains($0) == false })
        let keywords = user_keywords.joined(separator: ", ")
        
        return keywords
    }
}
