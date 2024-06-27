//
//  InspectionView.swift
//  InspectIT
//
//  Created by Prasham Jain on 25/06/24.
//

import SwiftUI

struct InspectionView: View {
    @StateObject var viewModel: InspectionViewModel
    
    init(delegate: InspectionViewModelDelegate, response: InspectionResponse? = nil) {
        let inspectionViewModel = InspectionViewModel(inspectionNetworkService: InspectionNetworkService())
        inspectionViewModel.delegate = delegate
        if let response = response {
            inspectionViewModel.inspectionResponse = response
        }
        _viewModel = StateObject(wrappedValue: inspectionViewModel)
    }
    
    var body: some View {
        VStack {
            headerView()
            
            if let area = viewModel.inspectionResponse?.inspection.area {
                Text("Area: \(area.name)")
                    .padding(.horizontal)
                    .font(.headline)
            }
            
            if let inspectionType = viewModel.inspectionResponse?.inspection.inspectionType {
                Text("Inspection Type: \(inspectionType.name)")
                    .padding(.horizontal)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            
            if let categories = viewModel.inspectionResponse?.inspection.survey?.categories {
                inspectionListView(categories: categories)
            }
            
            Spacer()
            
            if viewModel.inspectionResponse?.inspection.inspectionStatus == .draft {
                submitButton()
            }
            
        }
        .onAppear {
            if viewModel.inspectionResponse == nil {
                viewModel.fetchInspection()
            }
            
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Submission"), message: Text(viewModel.errorMessage ?? ""), dismissButton: .default(Text("OK")))
        }
    }
    
    @ViewBuilder
    private func headerView() -> some View {
        HStack {
            Text("Inspection Details")
                .font(.title)
                .padding()
                .foregroundColor(.white)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(10)
                .shadow(radius: 10)
            Button(action: {
                viewModel.delegate?.closeInspectionView()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .shadow(radius: 10)
            }
        }
    }
    
    @ViewBuilder
    private func inspectionListView(categories: [Category]) -> some View {
        List(categories, id: \.id) { category in
            Section(header: Text(category.name).font(.headline).foregroundColor(.blue)) {
                ForEach(category.questions ?? [], id: \.id) { question in
                    questionView(question: question)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    @ViewBuilder
    private func questionView(question: Question) -> some View {
        VStack(alignment: .leading) {
            Text(question.name)
                .padding(.bottom, 5)
            
            Picker("Answer", selection: Binding(
                get: { question.selectedAnswerChoiceId ?? -1 },
                set: { newValue in
                    print("Selecting answer \(newValue) for question \(question.id)")
                    withAnimation {
                        viewModel.selectAnswer(for: question.id, answerId: newValue)
                    }
                }
            )) {
                ForEach(question.answerChoices ?? [], id: \.id) { choice in
                    AnswerChoiceView(choice: choice, isSelected: question.selectedAnswerChoiceId == choice.id)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .disabled(viewModel.inspectionResponse?.inspection.inspectionStatus == .completed)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    @ViewBuilder
    private func submitButton() -> some View {
        Button(action: {
            viewModel.submitInspection()
        }) {
            Text("Submit")
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
        }
        //        .disabled(!viewModel.allQuestionsAnswered())
    }
}

struct AnswerChoiceView: View {
    let choice: AnswerChoice
    let isSelected: Bool
    
    var body: some View {
        Text(choice.name)
            .tag(choice.id)
            .padding()
            .background(
                isSelected ? Color.blue : Color.clear
            )
            .foregroundColor(isSelected ? .white : .black)
            .cornerRadius(5)
            .shadow(radius: isSelected ? 5 : 0)
    }
}

struct InspectionView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = InspectionViewModel()
        InspectionView(delegate: viewModel as! InspectionViewModelDelegate)
    }
}
